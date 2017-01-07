class CreateZones < ActiveRecord::Migration
  def change
    create_table :zones, id: :uuid do |t|
      t.string :name, limit: 100

      t.timestamps null: false
    end
  end
end

