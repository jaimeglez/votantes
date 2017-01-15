class Voter < ActiveRecord::Base
  validates_presence_of :full_name, :address, :electoral_number, :section
end
