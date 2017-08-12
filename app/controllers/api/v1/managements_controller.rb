class Api::V1::ManagementsController < Api::V1::ApiBaseController
  respond_to :json

  def create
    management = Note.new(management_permit)
    if management.save
      render json: management, status: :ok
    else
      render json: management.errors, status: :unprocessable_entity
    end
  end

  private
    def management_permit
      params[:management][:voter_id] = current_api_v1_voter.id
      params[:management][:note_type] = 'management'

      params.require(:management).permit(
        :note, :voter_id, :note_type
      )
    end
end
