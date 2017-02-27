class Api::V1::VotersController < Api::V1::ApiBaseController
  swagger_controller :voters, "Voters", resource_path: "/api/v1"
  respond_to :json

  def index
    voters = Voter.active
    respond_with(voters)
  end

  def new
    voter = Voter.new
  end

  def create
    params[:voter] = params
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
    params[:voter] = params
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

  swagger_api :index do
    summary "Fetches all active voters"
    notes "List all active Voters (active field as true)"
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
  end

  swagger_api :create do
    summary "Creates a new Voter"
    notes "This creates a new Voter that it could be an user as well"
    param :form, :full_name, :string, :required, "Full name"
    param :form, :address, :string, :required, "Address"
    param :form, :electoral_number, :string, :required, "Electoral number"
    param :form, :section, :string, :required, "Seccion"
    param :form, :latitude, :string, :required, "Latitude"
    param :form, :longitude, :string, :required, "Longitude"
    param :form, :phone_number, :string, :required, "Phone number"
    param :form, :social_network, :string, :required, "Social network"
    param :form, :role, :integer, :required, "Role"
    param :form, :email, :string, :required, "Email address"
    param :form, :imported, :string, :required, "Imported"
    param :form, :password, :string, :required, "Password"
    param :form, :user_id, :string, :required, "User"
    param :form, :areas_ids, :string, :required, "Areas IDs"
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
  end

  swagger_api :show do
    summary "Fetches a single Voter"
    param :path, :id, :string, :required, "Voter ID"
    response :ok, "Success", :Voter
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
  end

  swagger_api :update do
    summary "Updates an existing Voter"
    param :path, :id, :string, :required, "Voter ID"
    param :form, :full_name, :string, :required, "Full name"
    param :form, :address, :string, :required, "Address"
    param :form, :electoral_number, :string, :required, "Electoral number"
    param :form, :section, :string, :required, "Seccion"
    param :form, :latitude, :string, :required, "Latitude"
    param :form, :longitude, :string, :required, "Longitude"
    param :form, :phone_number, :string, :required, "Phone number"
    param :form, :social_network, :string, :required, "Social network"
    param :form, :role, :integer,:required, "Role"
    param :form, :imported, :string, :required, "Imported"
    param :form, :user_id, :string, :required, "User"
    param :form, :areas_ids, :string, :required, "Areas IDs"
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
  end

  swagger_api :destroy do
    summary "Deletes logically an existing Voter"
    param :path, :id, :string, :required, "Voter ID"
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
