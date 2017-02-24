class Api::V1::VotersController < Api::V1::ApiBaseController
  respond_to :json

  def index
    voters = Voter.active
    respond_with(voters)
  end

  def new
    voter = Voter.new
  end

  def create
    voter = Voter.new(voter_permit)

    if voter.save
      render json: {
        status: 200,
        message: I18n.t('successful.new_voter'),
        voter: voter
      }.to_json
    else
      render json: {
        status: 400,
        message: voter.errors
      }.to_json
    end

  end

  def show
    voter = Voter.find(params[:id])
    respond_with(voter)
  end

  def edit
    voter = Voter.find(params[:id])
    respond_with(voter)
  end

  def update
    voter = Voter.find(params[:id])

    if voter.update(voter_permit)
      render json: {
        status: 200,
        message: I18n.t('successful.update_voter'),
        voter: voter
      }.to_json
    else
      render json: {
        status: 400,
        message: voter.errors
      }.to_json
    end
  end

  def destroy
    voter = Voter.find(params[:id])

    if voter.update_attribute(:active, false)
      render json: {
        status: 200,
        message: I18n.t('successful.delete_voter'),
        voter: voter
      }.to_json
    else
      render json: {
        status: 400,
        message: voter.errors
      }.to_json
    end
  end

  swagger_controller :voters, "Voters"
  swagger_api :index do
    summary "List all active Voters (active field as true)"
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
  end

  private
  def voter_permit
    params.require(:voter).permit(
      :address,
      :areas_ids,
      :active,
      :electoral_number,
      :email,
      :full_name,
      :imported,
      :latitude,
      :longitude,
      :password,
      :phone_number,
      :section,
      :social_network,
      :role,
      :user_id
    )
  end
end
