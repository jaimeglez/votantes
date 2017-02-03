class Admin::SectionsController < Admin::AdminBaseController
  before_filter :get_zones

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

    respond_to do |format|

      format.html
      format.json { render json: @sections }

    end
  end

  def new
    zone_id = params[:zone_id]
    @section = Section.new(zone_id: zone_id)
  end

  def create
    @section = Section.new(section_permit)
    if @section.save
      flash.now[:success] = 'Se creó la sección satisfactoriamente'
      redirect_to admin_sections_path
    else
      flash.now[:danger] = 'Hubo un error al crear la sección'
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
      flash.now[:success] = 'Se actualizó la sección satisfactoriamente'
      redirect_to admin_sections_path
    else
      flash.now[:danger] = 'Hubo un error al editar la sección'
      render :edit
    end
  end

  def destroy
    @section = Section.find(params[:id])
    if @section.destroy
      flash.now[:success] = 'Se eliminó la sección satisfactoriamente'
    else
      flash.now[:danger] = 'Hubo un error al eliminar la sección'
    end
    redirect_to admin_sections_path
  end

  private
    def section_permit
      params.require(:section).permit(:id, :name, :zone_id)
    end

    def get_zones
      @zones = Zone.all
    end

end
