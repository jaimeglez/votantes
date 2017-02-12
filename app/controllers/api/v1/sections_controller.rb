class Api::V1::SectionsController < Api::V1::ApiBaseController
  respond_to :json

  def index
    sections = Section.all
    respond_with(sections)
  end

end
