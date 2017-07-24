class LoadVoterDocumentJob < ActiveJob::Base
  queue_as :default

  def perform(voter_document_id, document)
    @voter_document = VoterDocument.find(voter_document_id)
    @voter_document.import(document)
  end

  
  after_perform do |job|
    @voter_document.set_imported
  end
end
