class Admin::SectionsController < Admin::AdminBaseController
  before_action :search_form, only: :index
  before_action :get_zones, only: [:index, :new, :edit]

  def index
    if params[:q].present?
      @sections = Section.build_search(params[:q]).order('name asc')
    else
      @sections = Section.all.order('name asc')
    end
  end

  def new
    @section = Section.new
    @coordinators = Voter.allowed_section_coordinators
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

  def edit
    @section = Section.find(params[:id])
    @coordinators = Voter.allowed_section_coordinators
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

  private
    def section_permit
      params.require(:section).permit(:name, :zone_id, :coordinator_id, :active)
    end

    def get_zones
      @zones = Zone.all
    end

    def search_form
      @coordinators = Voter.with_roles(Voter::SECTION_COORDINATOR)
      @q = params[:q] ||= {}
    end
end
