class Square < ActiveRecord::Base
  belongs_to :section
  belongs_to :zone

  validates_presence_of :name, :section_id
  validates_length_of :name, maximum: 100
end
