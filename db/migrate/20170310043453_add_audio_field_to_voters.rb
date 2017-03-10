class AddAudioFieldToVoters < ActiveRecord::Migration
  def change
    add_column :voters, :audio, :string
  end
end
