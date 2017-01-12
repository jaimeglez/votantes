class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections, id: :uuid do |t|
      t.string :name, limit: 100
      t.uuid :zone_id

      t.timestamps null: false
    end
  end
end
