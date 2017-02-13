class Message < ActiveRecord::Base
  store_accessor :receivers, :zones_ids, :sections_ids, :squares_ids
  attr_accessor :group_type
  mount_uploader :content_video, VideoUploader

  validate :file_size
  validates :content_video, presence: true, if: "msg_type == 'video'"
  validates :content_text, presence: true, if: "msg_type == 'text'"
  validates :group_type, presence: true
  validates :zones_ids, presence: true, if: "group_type == 'zones'"
  validates :sections_ids, presence: true, if: "group_type == 'sections'"
  validates :squares_ids, presence: true, if: "group_type == 'squares'"

  before_validation do |model|
    model.receivers['zones_ids'].reject!(&:blank?)
    model.receivers['sections_ids'].reject!(&:blank?)
    model.receivers['squares_ids'].reject!(&:blank?)
  end

  def file_size
    if content_video.size.to_f/(1000*1000) > 10
      errors.add(:content_video, "You cannot upload a file greater than 10 MB")
    end
  end
end
