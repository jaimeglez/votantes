class Admin::VotersController < Admin::AdminBaseController
  before_action :search_form, only: :index

  def index
    if params[:q].present?
      @voters = Voter.build_search(params[:q]).order('address asc').page(params[:page])
    else
      @voters = Voter.all.order('address asc').page(params[:page])
    end
  end

  def new
    @voter = Voter.new
  end

  def create
    @voter = Voter.new(voter_permit)
    if @voter.save
      flash.now[:success] = 'Se creó la persona satisfactoriamente'
      redirect_to admin_voters_path
    else
      flash.now[:danger] = 'Hubo un error al crear la persona'
      render :new
    end
  end

  def edit
    @voter = Voter.find(params[:id])
  end

  def update
    @voter = Voter.find(params[:id])
    if @voter.update(voter_permit)
      flash.now[:success] = 'Se actualizó la persona satisfactoriamente'
      redirect_to admin_voters_path
    else
      flash.now[:danger] = 'Hubo un error al editar la persona'
      render :edit
    end
  end

  def show
    @voter = Voter.find(params[:id])
  end

  private
    def voter_permit
      params[:voter].delete(:password) if params[:voter][:password].blank?
      params.require(:voter).permit(:full_name, :address, :email,
        :electoral_number, :latitude, :longitude, :phone_number,
        :social_network, :password, :area_id, :active
      )
    end

    def search_form
      # @sections = Section.active.includes(:zone)
      @q = params[:q] ||= {}
    end
end
