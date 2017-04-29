class Admin::ZonesController < Admin::AdminBaseController
  def index
    search = params[:search]

    @zones = Zone.all
    if(search && search[:name].present?)
      @zones = @zones.where("lower(full_name) LIKE ?", "%#{search[:name]}%")
    end
    @zones = @zones.page(params[:page]).per(10)
  end

  def new
    @zone = Zone.new
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

  def show
    @zone = Zone.find(params[:id])
  end

  def edit
    @zone = Zone.find(params[:id])
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

  def destroy
    @zone = Zone.find(params[:id])
    if @zone.destroy
      flash.now[:success] = 'Se eliminó la zona satisfactoriamente'
    else
      flash.now[:danger] = 'Hubo un error al eliminar la zona'
    end
    redirect_to admin_zones_path
  end

  def select_data
    @zones = Zone.all
    respond_to do |format|
      format.json { render json: @zones }
    end
  end

  private
    def zone_permit
      params.require(:zone).permit(:id, :name)
    end

end
