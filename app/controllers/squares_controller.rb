class SquaresController < ApplicationController
  before_filter :get_zones, only: [:new, :edit]
  before_filter :get_sections, only: [:new, :edit]

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
  end

  def new
    section_id = params[:section_id]
    @square = Square.new(section_id: section_id)
  end

  def create
    @square = Square.new(square_permit)
    if @square.save
      flash.now[:success] = 'Se creó la zona satisfactoriamente'
      redirect_to squares_path
    else
      flash.now[:warning] = 'Hubo un error al crear la zona'
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
      flash.now[:success] = 'Se actualizó la zona satisfactoriamente'
      redirect_to squares_path
    else
      flash.now[:warning] = 'Hubo un error al editar la zona'
      render :edit
    end
  end

  def destroy
    @square = Square.find(params[:id])
    if @square.destroy
      flash.now[:success] = 'Se eliminó la zona satisfactoriamente'
    else
      flash.now[:warning] = 'Hubo un error al eliminar la zona'
    end
    redirect_to squares_path
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
