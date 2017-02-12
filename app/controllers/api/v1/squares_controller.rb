class Api::V1::SquaresController < Api::V1::ApiBaseController
  respond_to :json

  def index
    squares = Square.all
    respond_with(squares)
  end

end
