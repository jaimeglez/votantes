class VoterDocument < ActiveRecord::Base
  include VoterFieldsBuilder

  mount_uploader :attachment, AttachmentUploader
  validates_presence_of :name, :attachment
  after_commit :store_voters_data, on: :create
  before_create :destroy_all_documents

  def store_voters_data
    VoterWorker.perform_at(30.seconds.from_now, id)
  end

  def destroy_all_documents
    VoterDocument.destroy_all
  end

end
