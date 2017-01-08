class SectionsController < ApplicationController
  before_filter :get_zones, only: [:new, :edit]

  def index
    zone_id = params[:zone_id]
    search = params[:search]

    if zone_id
      @sections = Section.includes(:zone).where(zone_id: zone_id)
    else
      @sections = Section.all.includes(:zone)
    end
    if(search && search[:name].present?)
      @sections = @sections.where("name LIKE ?", "%#{search[:name]}%")
    end
  end

  def new
    zone_id = params[:zone_id]
    @section = Section.new(zone_id: zone_id)
  end

  def create
    @section = Section.new(section_permit)
    if @section.save
      flash.now[:success] = 'Se creó la zona satisfactoriamente'
      redirect_to sections_path
    else
      flash.now[:warning] = 'Hubo un error al crear la zona'
      render :new
    end
  end

  def show
    @section = Section.find(params[:id])
  end

  def edit
    @section = Section.find(params[:id])
  end

  def update
    @section = Section.find(params[:id])
    if @section.update(section_permit)
      flash.now[:success] = 'Se actualizó la zona satisfactoriamente'
      redirect_to sections_path
    else
      flash.now[:warning] = 'Hubo un error al editar la zona'
      render :edit
    end
  end

  def destroy
    @section = Section.find(params[:id])
    if @section.destroy
      flash.now[:success] = 'Se eliminó la zona satisfactoriamente'
    else
      flash.now[:warning] = 'Hubo un error al eliminar la zona'
    end
    redirect_to sections_path
  end

  private
    def section_permit
      params.require(:section).permit(:id, :name, :zone_id)
    end

    def get_zones
      @zones = Zone.all
    end

end
