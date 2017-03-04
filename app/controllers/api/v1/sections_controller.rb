class Api::V1::SectionsController < Api::V1::ApiBaseController
  before_action :authenticate_api_v1_voter!
  respond_to :json

  def index
    zone_id = params[:zone_id]
    if zone_id
      sections = Section.where(zone_id: zone_id)
    else
      sections = Section.all
    end
    respond_with sections
  end

  swagger_controller :zones, "Sections Management", resource_path: "/api/v1"
  swagger_api :index do
    summary "Fetches all sections"
    notes "This lists all the sections"
    param :query, :zone_id, :string, :optional, "Filter per zone_id"
    param :header, 'access-token', :string, :required, 'Access token'
    param :header, 'token-type', :string, :required, 'Token type'
    param :header, 'client', :string, :required, 'Client'
    param :header, 'expiry', :string, :required, 'Expiry'
    param :header, 'uid', :string, :required, 'Email'
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
  end

end
