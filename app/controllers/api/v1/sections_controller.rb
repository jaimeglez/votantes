class Api::V1::SectionsController < Api::V1::ApiBaseController
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

end
