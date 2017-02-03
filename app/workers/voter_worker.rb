class VoterWorker
  include Sidekiq::Worker

  def perform(document_id)
    document = VoterDocument.last
    file_url = document.attachment_url

    begin
      VoterDocument.transaction do
        Voter.destroy_all
        VoterFieldsBuilder::One.parse_and_save_data(file_url)
      end

    rescue => error
      # raise ActiveRecord::Rollback
      document.destroy
      puts 'ocurrio un error relacionado con la cargada o parseo de datos --------------------------------------------'
    end
  end
end
