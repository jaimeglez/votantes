class Voter < ActiveRecord::Base
  # devise modules
  # +  # Include default devise modules.
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable
  include DeviseTokenAuth::Concerns::User

  # Audio recording field for uploading with Carrierwave
  mount_uploader :audio, AudioUploader

  # Associations
  has_many :zones,    class_name: 'Zone',    foreign_key: :coordinator_id
  has_many :sections, class_name: 'Section', foreign_key: :coordinator_id
  has_many :squares,  class_name: 'Square',  foreign_key: :coordinator_id
  has_many :sympathizers, class_name: 'Voter',  foreign_key: :promoter_id
  belongs_to :square
  belongs_to :promoter, class_name: 'Voter'

  # Scopes
  scope :active, -> { where(active: true) }
  scope :with_roles, ->(roles){ where(role: roles) }
  scope :promoters, ->{ with_roles(PROMOTER) }
  scope :sympathizers, ->{ with_roles(SYMPATHIZER) }

  # Role constants
  ZONE_COORDINATOR = 1
  SECTION_COORDINATOR = 2
  SQUARE_COORDINATOR = 3
  PROMOTER = 4
  SYMPATHIZER = 5

  ROLES = {
    ZONE_COORDINATOR => I18n.t('voter.roles.zone_coordinator'),
    SECTION_COORDINATOR => I18n.t('voter.roles.section_coordinator'),
    SQUARE_COORDINATOR => I18n.t('voter.roles.square_coordinator'),
    PROMOTER => I18n.t('voter.roles.promoter'),
    SYMPATHIZER => I18n.t('voter.roles.sympathizer'),
  }

  attr_accessor :from, :area_id

  IMPORT_FIELDS = %w(name f_last_name s_last_name address electoral_number phone_number email)

  # Callbacks
  validates_presence_of :name, :f_last_name, :s_last_name
  # validates :electoral_number, :latitude, :longitude, :phone_number, :social_network, 
  #   :role, :email, :address, presence: true, if: :created_from_app?

  # before_validation :check_user_permissions, on: :create, if: :user_created_from_app?
  before_validation :add_rand_password, on: :create
  before_validation :associate_coordinations, on: :create, if: :created_from_app?
  before_validation :add_default_role
  after_commit :welcome_email, on: :create, if: :created_from_app?

  def role_name
    ROLES[self.role]
  end

  def full_name
    "#{name} #{f_last_name} #{s_last_name}"
  end

  def areas
    case role
    when ZONE_COORDINATOR
      self.zones
    when SECTION_COORDINATOR
      self.sections
    when SQUARE_COORDINATOR
      self.squares
    else
      if !promoter_id.nil?
        self.promoter
      else
        self.square
      end
    end
  end

  def self.allowed_zone_coordinators
    with_roles([ZONE_COORDINATOR, PROMOTER, SYMPATHIZER])
  end

  def self.allowed_section_coordinators
    with_roles([SECTION_COORDINATOR, PROMOTER, SYMPATHIZER])
  end

  def self.allowed_square_coordinators
    with_roles([SQUARE_COORDINATOR, PROMOTER, SYMPATHIZER])
  end

  def self.build_search(params)
    search(
      name_or_f_last_name_or_s_last_name_like: params[:name], 
      address_like: params[:address], 
      role_equals: params[:role],
      active_equals: params[:active],
      square_id_equals: params[:square],
      promoter_id_equals: params[:promoter]
    ).result
  end

  def add_promoter(params)
    self.role = PROMOTER
    self.square_id = params[:square_id]
    self.promoter_id = nil
    save
  end

  def remove_promoter
    remove_promoter_from_sympathizers
    self.role = SYMPATHIZER
    self.square_id = nil
    save
  end

  def add_sympathizer(params)
    self.role = SYMPATHIZER
    self.square_id = params[:square_id]
    self.promoter_id = params[:promoter_id]
    save
  end

  def remove_sympathizer
    self.role = SYMPATHIZER
    self.square_id = nil
    self.promoter_id = nil
    save
  end

  def assign_coodination(role)
    self.role = role
    self.square_id = nil
    self.promoter_id = nil
    self.save
  end

  def self.sympathizers_count
    with_roles([PROMOTER, SYMPATHIZER]).count
  end

  def self.coordinators_count
    with_roles([ZONE_COORDINATOR, SECTION_COORDINATOR, SQUARE_COORDINATOR]).count
  end

  def email_required?
    false
  end

  private

    def remove_promoter_from_sympathizers
      sympathizers.update_all(promoter_id: nil)
    end

    def created_from_app?
      return true if from == 'app'
    end

    # def check_user_permissions
    #   user = Voter.find( self.user_id )

    #   if user.role > self.role
    #     self.errors.add(:base, I18n.t('custom.role_hierarchy_validation'))
    #     return false
    #   end

    #   if user.role == PROMOTER && self.role == SYMPATHIZER
    #     user_sympathizers = Voter.where(role: SYMPATHIZER, user_id: user.id)

    #     if user_sympathizers.count > 9
    #       self.errors.add(:base, I18n.t('custom.role_sympathizers_limit'))
    #       return false
    #     end
    #   end

    # end

    def add_default_role
      self.role = SYMPATHIZER if self.role.nil?
    end

    def add_rand_password
      return unless self.password.blank?
      self.password = (0...10).map { (65 + rand(26)).chr }.join
    end

    def associate_coordinations
      if [ZONE_COORDINATOR, SECTION_COORDINATOR, SQUARE_COORDINATOR].include?(role) \
        && areas_ids.blank?
        self.errors.add(:base, I18n.t('custom.role_missing_areas_ids'))
        return false
      end

      case role
      when ZONE_COORDINATOR
        areas_to_relate = Zone.where(id: eval(areas_ids))
      when SECTION_COORDINATOR
        areas_to_relate = Section.where(id: eval(areas_ids))
      when SQUARE_COORDINATOR
        areas_to_relate = Square.where(id: eval(areas_ids))
      else
        return
      end

      areas_to_relate.each do |area|
        area.update_attribute(:coordinator_id, id)
      end
    end

    def welcome_email
      enc = Devise.token_generator.generate(self.class, :reset_password_token)
      update_columns(reset_password_token: enc[1], reset_password_sent_at: Time.now.utc)
      VoterMailer.download_app_email(self).deliver_now
    end
end
