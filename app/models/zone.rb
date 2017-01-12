class Zone < ActiveRecord::Base
  has_many :sections, dependent: :restrict_with_error

  validates_presence_of :name
  validates_associated :sections
  validates_length_of :name, maximum: 100

end
