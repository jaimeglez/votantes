class Voter < ActiveRecord::Base

  attr_accessor :imported

  validates_presence_of :full_name, :address, :electoral_number, :section
  validates :latitude, :longitude, :phone_number, :social_network, :role, :email,
    presence: true, if: :user_created_from_app?

  def user_created_from_app?
    return true if not imported
  end

end
