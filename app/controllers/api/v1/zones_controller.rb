class Api::V1::ZonesController < Api::V1::ApiBaseController
  swagger_controller :zones, "Zones Management", resource_path: "/app/swagger/zones.rb"
  respond_to :json

  def index
    zones = Zone.all
    respond_with(zones)
  end

end
