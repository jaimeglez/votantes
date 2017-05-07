class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages, id: :uuid do |t|
      t.string :msg_type
      t.string :content_video
      t.text   :content_text
      t.hstore :receivers

      t.timestamps null: false
    end
  end
end
