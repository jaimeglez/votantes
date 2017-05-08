class Admin::SquaresController < Admin::AdminBaseController
  before_action :search_form, only: :index
  before_filter :get_sections, only: [:index, :new, :edit]

  def index
    if params[:q].present?
      @squares = Square.build_search(params[:q]).order('name asc')
    else
      @squares = Square.all.includes(:coordinator, section: :zone).order('name asc')
    end
  end

  def new
    @square = Square.new
    @coordinators = Voter.allowed_square_coordinators
  end

  def create
    @square = Square.new(square_permit)
    if @square.save
      flash.now[:success] = 'Se creó la manzana satisfactoriamente'
      redirect_to admin_squares_path
    else
      flash.now[:danger] = 'Hubo un error al crear la manzana'
      render :new
    end
  end

  def show
    @square = Square.find(params[:id])
  end

  def edit
    @square = Square.find(params[:id])
    @coordinators = Voter.allowed_square_coordinators
  end

  def update
    @square = Square.find(params[:id])
    if @square.update(square_permit)
      flash.now[:success] = 'Se actualizó la manzana satisfactoriamente'
      redirect_to admin_squares_path
    else
      flash.now[:danger] = 'Hubo un error al editar la manzana'
      render :edit
    end
  end

  private
    def square_permit
      params.require(:square).permit(:name, 
        :section_id, :coordinator_id, :active)
    end

    def get_sections
      @sections = Section.all.includes(:zone)
    end

    def search_form
      @coordinators = Voter.with_roles(Voter::SQUARE_COORDINATOR)
      @q = params[:q] ||= {}
    end
end
