class ChangeVoterBirthdateToString < ActiveRecord::Migration
  def change
    change_column :voters, :birth_date, :string
  end
end
