class CreateVoters < ActiveRecord::Migration
  def change
    create_table :voters, id: :uuid do |t|
      t.string :full_name, limit: 150
      t.string :address
      t.string :electoral_number, limit: 18
      t.string :section

      t.timestamps null: false
    end
  end
end
