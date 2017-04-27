class Section < ActiveRecord::Base
  has_many :squares, dependent: :restrict_with_error
  belongs_to :zone
  belongs_to :voter, foreign_key: :coordinator_id

  validates_presence_of :name, :zone_id
  validates_associated :squares
  validates_length_of :name, maximum: 100

end
