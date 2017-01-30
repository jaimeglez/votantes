class AddIndexToVoter < ActiveRecord::Migration
  def change
    add_index :voters, :electoral_number, unique: true
  end
end
