class Voter < ActiveRecord::Base
  # devise modules
  # +  # Include default devise modules.
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable
  # include DeviseTokenAuth::Concerns::User

  # Associations
  has_many :zones,    class_name: 'Zone',    foreign_key: :coordinator_id
  has_many :sections, class_name: 'Section', foreign_key: :coordinator_id
  has_many :squares,  class_name: 'Square',  foreign_key: :coordinator_id

  # Role constants
  ZONE_COORDINATOR = 1;
  SECTION_COORDINATOR = 2;
  SQUARE_COORDINATOR = 3;
  PROMOTER = 4;
  SYMPATHIZER = 5;

  attr_accessor :imported

  validates_presence_of :full_name, :address, :electoral_number, :section
  validates :latitude, :longitude, :phone_number, :social_network, :role, :email, :user_id,
    presence: true, if: :user_created_from_app?

  before_validation :check_user_permissions, on: :create
  before_validation :check_electoral_number, on: :create
  before_create :add_default_role, :set_active
  validates :electoral_number, uniqueness: true

  private

  def user_created_from_app?
    return true unless imported
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

  # overrides methods fromo devise
  protected

  # TODO check why is always requiring Email.
  def email_required?
    imported ? false : true
  end

  def password_required?
    imported ? false : true
  end

end
