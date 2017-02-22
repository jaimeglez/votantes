swagger_controller :zones, "Zones Management"

swagger_api :index do
  summary "Fetches all zones"
  notes "This lists all the zones"
  param :query, :page, :integer, :optional, "Page number"
  param :path, :nested_id, :integer, :optional, "Team Id"
  response :unauthorized
  response :not_acceptable, "The request you made is not acceptable"
  response :requested_range_not_satisfiable
end
