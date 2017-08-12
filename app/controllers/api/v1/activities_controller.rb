class Api::V1::ActivitiesController < Api::V1::ApiBaseController
  respond_to :json

  def create
    activity = Note.new(activity_permit)
    if activity.save
      render json: activity, status: :ok
    else
      render json: activity.errors, status: :unprocessable_entity
    end
  end

  private
    def activity_permit
      params[:activity][:voter_id] = current_api_v1_voter.id
      params[:activity][:note_type] = 'activity'

      params.require(:activity).permit(
        :note, :voter_id, :note_type
      )
    end
end