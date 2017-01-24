class Message < ActiveRecord::Base
  store_accessor :content, :content_video, :content_text
  mount_uploader :content_video, VideoUploader, serialize_to: :content
  validate :file_size

  def file_size
    if content_video.size.to_f/(1000*1000) > 10
      errors.add(:content_video, "You cannot upload a file greater than 10 MB")
    end
  end
end
