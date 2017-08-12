class RemoveEmailIndexFromVoters < ActiveRecord::Migration
  def change
    remove_index :voters, column: :email 
    remove_index :voters, column: [:uid, :provider]
    change_column :voters, :email, :string, :null => true
    change_column :voters, :provider, :string, :null => true, :default => "email"
    change_column :voters, :uid, :string, :null => true, :default => ""
    change_column :voters, :electoral_number, :string, :null => true, :default => ""
  end
end
