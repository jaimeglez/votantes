class Square < ActiveRecord::Base
  belongs_to :section
  belongs_to :coordinator, class_name: Voter, foreign_key: :coordinator_id
  has_many :voters
  
  validates :name, presence: true, length: { maximum: 100 }
  validates :section_id, presence: true
  validates_associated :section

  scope :active, ->{ joins(section: :zone).where("squares.active = true
    AND sections.active = true AND zones.active = true") }
  scope :by_section, ->(section_id){ where(section_id: section_id) }

  def self.build_search(params)
    search(
      name_like: params[:name], 
      section_id_equals: params[:zone],
      coordinator_id_equals: params[:coordinator],
      active_equals: params[:active]
    ).result
  end
end
