class Api::V1::VotersController < Api::V1::ApiBaseController
  respond_to :json

  def update
    voter = Voter.find_or_new(voter_permit)
    if voter.save
      render json: voter, status: :ok
    else
      render json: voter.errors, status: :unprocessable_entity
    end
  end

  private
    def voter_permit
      params[:voter][:added_by_id] = current_api_v1_voter.id
      params[:voter][:from] = 'app'

      params.require(:voter).permit(
        :name,
        :f_last_name,
        :s_last_name,
        :latitude,
        :longitude,
        :street,
        :ext_num,
        :int_num,
        :neighborhood,
        :phone_number,
        :social_network,
        :area_id,
        :role,
        :added_by_id,
        :email,
        :birth_date,
        :electoral_number,
        :active,
        :from,
        :gender,
        :id,
        :old_area_id
      )
    end
end
