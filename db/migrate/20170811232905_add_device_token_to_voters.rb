class AddDeviceTokenToVoters < ActiveRecord::Migration
  def change
    add_column :voters, :device_token, :string, index: true
  end
end
