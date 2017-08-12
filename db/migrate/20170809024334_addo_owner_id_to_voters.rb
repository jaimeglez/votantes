class AddoOwnerIdToVoters < ActiveRecord::Migration
  def change
    add_column :voters, :added_by_id, :uuid, index: true
  end
end
