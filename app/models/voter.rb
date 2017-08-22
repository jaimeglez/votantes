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
  has_many :contacts, class_name: 'Voter',  foreign_key: :added_by_id
  has_many :notes
  belongs_to :square
  belongs_to :promoter, class_name: 'Voter'

  # Validations
  validates_presence_of :name, :f_last_name, :street, :ext_num, 
    :neighborhood, :gender
  validates_presence_of :role, if: :created_from_app?
  validates :email, uniqueness: true, allow_nil: true
  validates :electoral_number, uniqueness: true, allow_nil: true

  # Callbacks
  before_validation :add_rand_password, on: :create
  before_validation :add_default_role, on: :create, if: Proc.new { |v| v.role.nil? }
  before_validation :set_uid
  before_validation :set_role, if: :created_from_app?
  after_save :assign_area_by_role, if: :created_from_app?
  before_save :welcome_email, if: :send_welcome_email?

  # Scopes
  scope :active, -> { where(active: true) }
  scope :with_roles, ->(roles){ where(role: roles) }
  scope :promoters, ->{ with_roles(PROMOTER) }
  scope :sympathizers, ->{ with_roles(SYMPATHIZER) }

  attr_accessor :from, :area_id, :old_area_id

  # constants
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

  IMPORT_FIELDS = %w(name f_last_name s_last_name birth_date gender street ext_num int_num neighborhood email electoral_number phone_number social_network)
  GROUPS = %w(group1 group2 group3 group4 group5)

  def token_validation_response
    {
      id: id,
      role: role,
      areas: areas_with_subareas
    }
  end

  def role_name
    ROLES[self.role]
  end

  def full_name
    "#{name} #{f_last_name} #{s_last_name}"
  end

  def address
    "#{street} #{ext_num} #{int_num} #{neighborhood}"
  end

  def areas
    case role
    when ZONE_COORDINATOR
      self.zones
    when SECTION_COORDINATOR
      self.sections
    when SQUARE_COORDINATOR
      self.squares
    when PROMOTER
      self.sympathizers
    else
      []
    end
  end

  def areas_with_subareas
    case role
    when ZONE_COORDINATOR
      zones.with_childrens
    when SECTION_COORDINATOR
      sections.with_childrens
    else
      []
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

  def reassign_role(role)
    return unless self.areas.size.zero?
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

  def self.find_or_new(params)
    if params[:email] || params[:electoral_number] || params[:id]
      voter = get_voter(params)
      build_voter(voter, params)
    else
      Voter.new(params)
    end
  end

  def set_device_token(device_token)
    Voter.where(device_token: device_token).update_all(device_token: nil)
    self.device_token = device_token
  end

  def self.by_area(type, ids)
    case(type)
    when 'zones'
      by_zones(ids)
    when 'sections'
      by_sections(ids)
    when 'squares'
      by_squares(ids)
    end
  end

  def self.by_zones(zone_ids)
    voters = joins(square: [section: :zone]).where('zones.id IN (?) AND voters.device_token IS NOT NULL', zone_ids).pluck(:id)
    coordinators = Zone.coordinators(zone_ids)
    voters + coordinators
  end

  def self.by_sections(sections_ids)
    voters = joins(square: :section).where('sections.id IN (?)', sections_ids).pluck(:id)
    coordinators = Section.coordinators(sections_ids)
    voters + coordinators
  end

  def self.by_squares(squares_ids)
    voters = joins(:square).where('square.id IN (?)', squares_ids).pluck(:id)
    coordinators = Square.coordinators(squares_ids)
    voters + coordinators
  end

  private
    def set_uid
      return unless self.uid.blank? || self.email_changed?
      self.uid = self.email
    end

    def set_role
      return if !self.role_changed? && area_id == old_area_id
      add_default_role if self.area_id.nil?
    end

    def assign_area_by_role
      case(self.role)
      when 2
        section = Section.find_by(id: area_id) 
        return add_default_role if section.nil?
        section.coordinator_id = self.id
        section.save
      when 3
        square = Square.find_by(id: area_id) 
        return add_default_role if square.nil?
        square.coordinator_id = self.id
        square.save
      when 4
        Voter.where(square_id: area_id).update_all(promoter_id: id)
      end
    end

    def remove_promoter_from_sympathizers
      sympathizers.update_all(promoter_id: nil)
    end

    def created_from_app?
      from == 'app'
    end

    def add_default_role
      self.role = SYMPATHIZER
    end

    def add_rand_password
      return unless self.password.blank?
      self.password = (0...10).map { (65 + rand(26)).chr }.join
    end

    def send_welcome_email?
      !email.blank? && created_from_app? && email_was != email
    end

    def welcome_email
      enc = Devise.token_generator.generate(self.class, :reset_password_token)
      update_columns(reset_password_token: enc[1], reset_password_sent_at: Time.now.utc)
      VoterMailer.download_app_email(self).deliver_now
    end

    def self.get_voter(params)
      if params[:id]
        Voter.find_by(id: params[:id])
      else
        return nil unless params[:email] || params[:electoral_number]
        where_params = {}
        where_params[:email] = params[:email] if params[:email]
        where_params[:electoral_number] = params[:electoral_number] if params[:electoral_number]
        find_by(where_params)
      end
    end

    def self.build_voter(voter, params)
      if voter.nil?
        Voter.new(params)
      else
        voter.assign_attributes(params)
        voter
      end
    end
end
