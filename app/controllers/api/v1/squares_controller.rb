class Api::V1::SquaresController < Api::V1::ApiBaseController
  before_action :authenticate_api_v1_voter!
  respond_to :json

  def index
    zone_id = params[:zone_id]
    section_id = params[:section_id]
    if zone_id
      squares = Square.where(zone_id: zone_id)
    elsif section_id
      squares = Square.where(section_id: section_id)
    else
      squares = Square.all
    end
    respond_with squares
  end

  swagger_controller :zones, "Squares Management", resource_path: "/api/v1"
  swagger_api :index do
    summary "Fetches all squares"
    notes "This lists all the squares, you can filter the squares per zone or section, if you send both values, the api will return by the zone filter since zone has high priority"
    param :query, :zone_id, :string, :optional, "Filter per zone_id"
    param :query, :section_id, :string, :optional, "Filter per section_id"
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
