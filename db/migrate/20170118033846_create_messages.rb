class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :msg_type
      t.string :content

      t.timestamps null: false
    end
  end
end
