class AddExtraFieldsToVoters < ActiveRecord::Migration
  def change
    add_column :voters, :birth_date, :date
    add_column :voters, :gender, :string
    add_column :voters, :street, :string
    add_column :voters, :ext_num, :string
    add_column :voters, :int_num, :string
    add_column :voters, :neighborhood, :string
    remove_column :voters, :address, :string
  end
end
