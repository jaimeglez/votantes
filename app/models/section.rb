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
      return if self.coordinator_id.nil? || !self.coordinator_id_changed?
      self.coordinator.assing_role(Voter::SECTION_COORDINATOR)
    end
end
