class AddPendingFieldsToVoters < ActiveRecord::Migration
  def change
    add_column :voters, :latitude, :string
    add_column :voters, :longitude, :string
    add_column :voters, :phone_number, :string
    add_column :voters, :social_network, :string
    add_column :voters, :role, :string
    add_column :voters, :email, :string
  end
end
