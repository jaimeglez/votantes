class Message < ActiveRecord::Base
  mount_uploader :content_video, VideoUploader
  validate :file_size
  validates :content_video, presence: true, if: "msg_type == 'video'"
  validates :content_text, presence: true, if: "msg_type == 'text'"

  def file_size
    if content_video.size.to_f/(1000*1000) > 10
      errors.add(:content_video, "You cannot upload a file greater than 10 MB")
    end
  end
end
