class Note < ActiveRecord::Base
  belongs_to :voter

  validates :note, presence: true
  validates :note_type, presence: true
  validates :voter_id, presence: true

  enum note_type: { management: 0, activity: 1 }

  scope :management, ->{ where(note_type: 0) }
  scope :activity, ->{ where(note_type: 1) }

  def self.build_search(params)
    search(
      note_type_equals: note_types[params[:note_type]],
      voter_id_equals: params[:voter]
    ).result
  end
end
