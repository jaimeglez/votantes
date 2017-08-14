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

  after_create :send_notification

  def file_size
    if content_video.size.to_f/(1000*1000) > 10
      errors.add(:content_video, "You cannot upload a file greater than 10 MB")
    end
  end

  private
    def send_notification
      # fcm = FCM.new(Rails.application.secrets.fcm_key)
      # voters = Voter.by_area(group_type, receivers["#{group_type}_ids"])
      # registration_ids = Voter.where(id: voters).pluck(:device_token)
      # options = {data: {message: "Nuevo mensaje", title: 'Red Ciudadana', msg_type: msg_type, content: content_by_type}}
      # response = fcm.send(registration_ids, options)
    end

    def content_by_type
      return content_text if msg_type == 'text'
      self.content_video.url
    end
end
