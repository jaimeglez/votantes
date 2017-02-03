class NewChangesToVoter < ActiveRecord::Migration
  def change
    add_index :voters, :electoral_number, unique: true
    remove_column :voters, :email
    add_column :voters, :active, :boolean
  end
end
