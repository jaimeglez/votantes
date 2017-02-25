class AddMissingFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users,    :full_name, :string
    add_column :users,    :address, :string
    add_column :users,    :electoral_number, :string, limit: 18
    add_column :users,    :section, :string
    add_column :users,    :latitude, :string
    add_column :users,    :longitude, :string
    add_column :users,    :phone_number, :string
    add_column :users,    :social_network, :string
    add_column :users,    :role, :string
    add_index  :users,    :electoral_number, unique: true
    add_column :users,    :active, :boolean
    add_column :users,    :user_id, :uuid
    change_column :users, :role, 'integer USING CAST(role AS integer)'
  end
end
