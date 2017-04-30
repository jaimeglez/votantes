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

  # Scopes
  scope :active, -> { where(active: true) }
  scope :per_role, ->(roleId) { where(role: roleId) }

  # Role constants
  ZONE_COORDINATOR = 1
  SECTION_COORDINATOR = 2
  SQUARE_COORDINATOR = 3
  PROMOTER = 4
  SYMPATHIZER = 5

  ROLES = {
    1 => I18n.t('voter.roles.zone_coordinator'),
    2 => I18n.t('voter.roles.section_coordinator'),
    3 => I18n.t('voter.roles.square_coordinator'),
    4 => I18n.t('voter.roles.promoter'),
    5 => I18n.t('voter.roles.sympathizer'),
  }

  attr_accessor :imported, :areas_ids

  # Callbacks
  validates_presence_of :full_name, :address, :electoral_number, :section
  validates :electoral_number, uniqueness: true
  validates :latitude, :longitude, :phone_number, :social_network, :role, :email, :user_id,
    presence: true, if: :user_created_from_app?

  before_validation :check_user_permissions, :associate_coordinations, on: :create, if: :user_created_from_app?
  before_validation :check_electoral_number, :add_rand_password, on: :create
  before_create :add_default_role, :set_active
  after_commit :send_download_app_email, on: :create, if: :user_created_from_app?

  def role_name(role_number)
    ROLES[role_number]
  end

  private

  def user_created_from_app?
    return true if !imported || imported == 'false'
  end

  def check_electoral_number
    voter = Voter.find_by(electoral_number: self.electoral_number)

    if voter.nil?
      # Send push notification saying that need to check Electoral Number
      return
    end

  end

  def check_user_permissions
    user = Voter.find( self.user_id )

    if user.role > self.role
      self.errors.add(:base, I18n.t('custom.role_hierarchy_validation'))
      return false
    end

    if user.role == PROMOTER && self.role == SYMPATHIZER
      user_sympathizers = Voter.where(role: SYMPATHIZER, user_id: user.id)

      if user_sympathizers.count > 9
        self.errors.add(:base, I18n.t('custom.role_sympathizers_limit'))
        return false
      end
    end

  end

  def add_default_role
    self.role = SYMPATHIZER if self.role.nil?
  end

  def set_active
    self.active = true
  end

  def add_rand_password
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

  def send_download_app_email
    enc = Devise.token_generator.generate(self.class, :reset_password_token)
    update_columns(reset_password_token: enc[1], reset_password_sent_at: Time.now.utc)
    VoterMailer.download_app_email(self).deliver_now
  end

end
