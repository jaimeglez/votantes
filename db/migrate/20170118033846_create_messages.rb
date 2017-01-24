class CreateMessages < ActiveRecord::Migration
  def change
    enable_extension "hstore"
    create_table :messages, id: :uuid do |t|
      t.string :msg_type
      t.hstore :content

      t.timestamps null: false
    end
  end
end
