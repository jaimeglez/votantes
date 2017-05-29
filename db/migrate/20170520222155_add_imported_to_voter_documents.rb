class AddImportedToVoterDocuments < ActiveRecord::Migration
  def change
    add_column :voter_documents, :imported, :boolean, default: false
  end
end
