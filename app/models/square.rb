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
  
  after_save :assing_voter_coordination

  def with_parents_name
    "#{section.with_parents_name} - #{name}"
  end

  def with_section_name
    "#{section.name} - #{name}"
  end

  def self.build_chart(section_name)
    labels = []
    data = []
    section = Section.find_by(name: section_name)
    unless section.nil?
      section.squares.includes(:voters).each do |square|
        labels << square.name
        data << square.voters.size
      end
    end
    [labels, data]
  end

  def self.build_search(params)
    search(
      name_like: params[:name], 
      section_id_equals: params[:section],
      coordinator_id_equals: params[:coordinator],
      active_equals: params[:active]
    ).result
  end

  def self.coordinators(squares_ids)
    where(id: squares_ids).pluck(:coordinator_id)
  end

  private
    def assing_voter_coordination
      return unless self.coordinator_id_changed?
      remove_old_coordination
      return if self.coordinator_id.nil?
      self.coordinator.reassign_role(Voter::SQUARE_COORDINATOR)
    end

    def remove_old_coordination
      voter = Voter.find_by(id: self.coordinator_id_was)
      return if voter.nil?
      voter.reassign_role(Voter::SYMPATHIZER)
    end
end
