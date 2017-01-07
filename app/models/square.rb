class Square < ActiveRecord::Base
  validates_presence_of :name
  validates_length_of :name, maximum: 100
end
