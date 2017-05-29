class AddNameLastNameToVoters < ActiveRecord::Migration
  def change
    remove_column :voters, :full_name, :string
    add_column :voters, :name, :string
    add_column :voters, :f_last_name, :string
    add_column :voters, :s_last_name, :string
  end
end
