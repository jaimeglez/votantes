class CreateVoterDocuments < ActiveRecord::Migration
  def change
    create_table :voter_documents, id: :uuid do |t|
      t.string :name
      t.string :attachment

      t.timestamps null: false
    end
  end
end
