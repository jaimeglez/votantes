class Section < ActiveRecord::Base
  has_many :squares, dependent: :restrict_with_error
  belongs_to :zone
  belongs_to :coordinator, class_name: Voter, foreign_key: :coordinator_id

  validates :name, presence: true, length: { maximum: 100 }
  validates_associated :zone

  default_scope ->{ order('name asc') }
  scope :active, ->{ where(active: true, zones: { active: true}) }
  scope :by_zone, ->(zone_id){ where(zone_id: zone_id) }

  after_save :assing_voter_coordination

  def with_parents_name
    "#{zone.name} - #{name}"
  end

  def self.with_childrens
    includes(:squares).map do |section|
      {
        id: section.id,
        name: section.name,
        squares: section.squares
      }
    end
  end

  def self.coordinators(sections_ids)
    coordinators = []
    where(id: sections_ids).includes(:squares).each do |section|
      coordinators << section.coordinator_id unless section.coordinator_id.nil?
      section.squares.each do |square|
        coordinators << square.coordinator_id unless square.coordinator_id.nil?
      end
    end
    coordinators
  end

  def self.build_chart(zone_name)
    labels = []
    data = []
    zone = Zone.find_by(name: zone_name)
    unless zone.nil?
      zone.sections.includes(:squares).each do |section|
        labels << section.name
        data << section.squares.size
      end
    end
    [labels, data]
  end

  def self.build_search(params)
    search(
      name_like: params[:name], 
      zone_id_equals: params[:zone],
      coordinator_id_equals: params[:coordinator],
      active_equals: params[:active]
    ).result
  end

  private
    def assing_voter_coordination
      return unless self.coordinator_id_changed?
      remove_old_coordination
      return if self.coordinator_id.nil?
      self.coordinator.reassign_role(Voter::SECTION_COORDINATOR)
    end

    def remove_old_coordination
      voter = Voter.find_by(id: self.coordinator_id_was)
      return if voter.nil?
      voter.reassign_role(Voter::SYMPATHIZER)
    end
end
