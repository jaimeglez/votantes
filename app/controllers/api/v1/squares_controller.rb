class Api::V1::SquaresController < Api::V1::ApiBaseController
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

end
