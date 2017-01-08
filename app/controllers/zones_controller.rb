class ZonesController < ApplicationController
  def index
    @zones = Zone.all
  end

  def new
    @zone = Zone.new
  end

  def create
    @zone = Zone.new(zone_permit)
    if @zone.save
      flash.now[:success] = 'Se creó la zona satisfactoriamente'
      redirect_to zones_path
    else
      flash.now[:warning] = 'Hubo un error al crear la zona'
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
      redirect_to zones_path
    else
      flash.now[:warning] = 'Hubo un error al editar la zona'
      render :edit
    end
  end

  def destroy
    @zone = Zone.find(params[:id])
    if @zone.destroy
      flash.now[:success] = 'Se eliminó la zona satisfactoriamente'
    else
      flash.now[:warning] = 'Hubo un error al eliminar la zona'
    end
    redirect_to zones_path
  end

  private
    def zone_permit
      params.require(:zone).permit(:id, :name)
    end

end
