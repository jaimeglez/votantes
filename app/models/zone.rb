class Zone < ActiveRecord::Base
  include Blondie::FormHelper

  has_many :sections, dependent: :restrict_with_error
  belongs_to :coordinator, class_name: Voter, foreign_key: :coordinator_id

  validates :name, presence: true, length: { maximum: 100 }

  scope :active, ->{ where(active: true) }

  after_save :assing_voter_coordination

  def self.build_search(params)
    search(
      name_like: params[:name], 
      coordinator_id_equals: params[:coordinator],
      active_equals: params[:active]
    ).result
  end

  private
    def assing_voter_coordination
      return if self.coordinator_id.nil? || !self.coordinator_id_changed?
      self.coordinator.assing_role(Voter::ZONE_COORDINATOR)
    end
end
