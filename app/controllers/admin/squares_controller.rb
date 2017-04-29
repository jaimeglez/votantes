class Admin::SquaresController < Admin::AdminBaseController
  before_filter :get_zones
  before_filter :get_sections

  def index
    section_id = params[:section_id]
    search = params[:search]

    if section_id
      @squares = Square.includes(:section).where(section_id: section_id)
    else
      @squares = Square.all.includes(:section)
    end
    if(search && search[:name].present?)
      @squares = @squares.where("name LIKE ?", "%#{search[:name]}%")
    end
    @squares = @squares.page(params[:page]).per(10)
  end

  def new
    section_id = params[:section_id]
    zone_id = params[:zone_id]
    @square = Square.new(section_id: section_id, zone_id: zone_id)
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

  def destroy
    @square = Square.find(params[:id])
    if @square.destroy
      flash.now[:success] = 'Se eliminó la manzana satisfactoriamente'
    else
      flash.now[:danger] = 'Hubo un error al eliminar la manzana'
    end
    redirect_to admin_squares_path
  end

  def select_data
    @squares = Square.all
    respond_to do |format|
      format.json { render json: @squares }
    end
  end

  private
    def square_permit
      params.require(:square).permit(:id, :name, :zone_id, :section_id)
    end

    def get_zones
      @zones = Zone.all
    end

    def get_sections
      @sections = Section.all
    end
end
