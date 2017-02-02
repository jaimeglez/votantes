class Voter < ActiveRecord::Base
  # Role constants
  ZONE_COORDINATOR = 1;
  SECTION_COORDINATOR = 2;
  SQUARE_COORDINATOR = 3;
  PROMOTER = 4;
  SYMPATHIZER = 5;

  attr_accessor :imported

  validates_presence_of :full_name, :address, :electoral_number, :section
  validates :latitude, :longitude, :phone_number, :social_network, :role, :email,
    presence: true, if: :user_created_from_app?

  before_validation :check_electoral_number, on: :create
  before_create :add_default_role

  private

  def user_created_from_app?
    return true if not imported
  end

  def check_electoral_number
    voter = Voter.find_by(electoral_number: self.electoral_number)

    if voter.nil?
      puts 'Saving but need to check the electoral number'
      return
    end

  end

  def add_default_role
    self.role = SYMPATHIZER if self.role.nil?
  end

end
