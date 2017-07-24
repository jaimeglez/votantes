class Zone < ActiveRecord::Base
  include Blondie::FormHelper

  has_many :sections, dependent: :restrict_with_error
  belongs_to :coordinator, class_name: Voter, foreign_key: :coordinator_id

  validates :name, presence: true, length: { maximum: 100 }

  scope :active, ->{ where(active: true) }

  after_save :assing_voter_coordination

  def with_parents_name
    name
  end

  def self.build_chart(parent)
    labels = []
    data = []
    Zone.all.includes(:sections).each do |zone|
      labels << zone.name
      data << zone.sections.size
    end
    [labels, data]
  end

  def self.build_search(params)
    search(
      name_like: params[:name], 
      coordinator_id_equals: params[:coordinator],
      active_equals: params[:active]
    ).result
  end

  private
    def assing_voter_coordination
      return unless self.coordinator_id_changed?
      if self.coordinator_id.nil?
        remove_coordination
      else
        self.coordinator.assign_coodination(Voter::ZONE_COORDINATOR)
      end
    end

    def remove_coordination
      voter = Voter.find_by(id: self.coordinator_id_was)
      return if voter.nil?
      voter.assign_coodination(Voter::SYMPATHIZER)
    end
end
