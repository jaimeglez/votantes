class VoterDocument < ActiveRecord::Base
  include VoterFieldsBuilder

  mount_uploader :attachment, AttachmentUploader
  validates_presence_of :name, :attachment
  after_create  :store_voters_data

  def store_voters_data
    VoterWorker.perform_at(1.minutes.from_now, id)
  end

end
