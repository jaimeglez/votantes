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

  def self.with_childrens
    includes(sections: :squares).map do |zone|
      {
        id: zone.id, 
        name: zone.name, 
        sections: zone.sections.with_childrens
      }
    end
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

  def self.coordinators(zone_ids)
    coordinators = []
    where(id: zone_ids).includes(sections: :squares).each do |zone|
      coordinators << zone.coordinator_id unless zone.coordinator_id.nil?
      zone.sections.each do |section|
        coordinators << section.coordinator_id unless section.coordinator_id.nil?
        section.squares.each do |square|
          coordinators << square.coordinator_id unless square.coordinator_id.nil?
        end
      end
    end
    coordinators
  end
  
  private
    def assing_voter_coordination
      return unless self.coordinator_id_changed?
      remove_old_coordination
      return if self.coordinator_id.nil?
      self.coordinator.reassign_role(Voter::ZONE_COORDINATOR)
    end

    def remove_old_coordination
      voter = Voter.find_by(id: self.coordinator_id_was)
      return if voter.nil?
      voter.reassign_role(Voter::SYMPATHIZER)
    end
end
