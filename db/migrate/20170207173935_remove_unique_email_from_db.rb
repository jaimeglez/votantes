class RemoveUniqueEmailFromDb < ActiveRecord::Migration
  def change
    remove_index :voters, :email
    remove_index :voters, name: 'index_voters_on_uid_and_provider'
  end
end
