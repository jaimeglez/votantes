class AddAssociationsToZonesSectionsSquares < ActiveRecord::Migration
  def change
    add_column :zones,    :coordinator_id, :uuid
    add_column :sections, :coordinator_id, :uuid
    add_column :squares,  :coordinator_id, :uuid
    add_column :voters,   :user_id,        :uuid
    change_column :voters,  :role, 'integer USING CAST(role AS integer)'
  end
end
