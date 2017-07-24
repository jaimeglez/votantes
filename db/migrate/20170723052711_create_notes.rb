class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes, id: :uuid do |t|
      t.text :note, null: false
      t.integer :note_type, null: false, index: true
      t.uuid :voter_id, index: true

      t.timestamps null: false
    end
  end
end
