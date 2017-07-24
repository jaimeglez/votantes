class Admin::ZonesController < Admin::AdminBaseController
  before_action :search_form, only: :index

  def index
    if params[:q].present?
      @zones = Zone.build_search(params[:q]).order('name asc').page(params[:page])
    else
      @zones = Zone.all.order('name asc').page(params[:page])
    end
  end

  def new
    @zone = Zone.new
    @coordinators = Voter.allowed_zone_coordinators
  end

  def create
    @zone = Zone.new(zone_permit)
    if @zone.save
      flash.now[:success] = 'Se creó la zona satisfactoriamente'
      redirect_to admin_zones_path
    else
      flash.now[:danger] = 'Hubo un error al crear la zona'
      render :new
    end
  end

  def edit
    @zone = Zone.find(params[:id])
    @coordinators = Voter.allowed_zone_coordinators
  end

  def update
    @zone = Zone.find(params[:id])
    if @zone.update(zone_permit)
      flash.now[:success] = 'Se actualizó la zona satisfactoriamente'
      redirect_to admin_zones_path
    else
      flash.now[:danger] = 'Hubo un error al editar la zona'
      render :edit
    end
  end

  def export
    @zone = Zone.includes(sections: {squares: :voters}).find(params[:id])
    respond_to do |format|
      format.xlsx
    end
  end

  private
    def zone_permit
      params.require(:zone).permit(:id, :name, :coordinator_id, :active)
    end

    def search_form
      @coordinators = Voter.with_roles(Voter::ZONE_COORDINATOR)
      @q = params[:q] ||= {}
    end
end
