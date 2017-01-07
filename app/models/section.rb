class Section < ActiveRecord::Base
  has_many :squares, dependent: :restrict_with_error

  validates_associated :squares
  validates_presence_of :name
  validates_length_of :name, maximum: 100

end
