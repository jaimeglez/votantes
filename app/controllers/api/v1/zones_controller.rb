class Api::V1::ZonesController < Api::V1::ApiBaseController
  respond_to :json

  def index
    zones = Zone.all
    respond_with(zones)
  end

  swagger_controller :zones, "Zones Management", resource_path: "/api/v1"
  swagger_api :index do
    summary "Fetches all zones"
    notes "This lists all the zones"
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
  end

end
