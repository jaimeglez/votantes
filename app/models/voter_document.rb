class VoterDocument < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
  validates_presence_of :name, :attachment
end
