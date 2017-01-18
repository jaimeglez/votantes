class Message < ActiveRecord::Base
  mount_uploader :content, VideoUploader
  validate :file_size

  def file_size
    if content.file.size.to_f/(1000*1000) > 10
      errors.add(:content, "You cannot upload a file greater than 10 MB")
    end
  end
end
