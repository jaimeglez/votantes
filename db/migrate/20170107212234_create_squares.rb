class CreateSquares < ActiveRecord::Migration
  def change
    create_table :squares, id: :uuid do |t|
      t.string :name, limit: 100
      t.uuid :section_id, index: true
      t.uuid :coordinator_id, index: true
      t.boolean :active, default: true, index: true

      t.timestamps null: false
    end
  end
end
