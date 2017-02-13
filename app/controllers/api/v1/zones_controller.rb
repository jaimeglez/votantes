class Api::V1::ZonesController < Api::V1::ApiBaseController
  respond_to :json

  def index
    zones = Zone.all
    respond_with(zones)
  end

end
