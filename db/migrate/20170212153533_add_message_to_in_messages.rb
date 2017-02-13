class AddMessageToInMessages < ActiveRecord::Migration
  def change
    enable_extension "hstore"
    add_column :messages, :receivers, :hstore
  end
end
