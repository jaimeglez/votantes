class AddPromoterToVoters < ActiveRecord::Migration
  def change
    add_column :voters, :promoter_id, :uuid, index: true
  end
end
