class Admin::SympathizersController < Admin::AdminBaseController
  before_action :search_form, only: :index
  before_action :get_promoters, only: [:index, :edit, :update]

  def index
    if params[:q].present?
      params[:q][:role] = Voter::SYMPATHIZER
      @sympathizers = Voter.build_search(params[:q]).order('name asc')
    else
      @sympathizers = Voter.sympathizers.includes(:promoter, square: {section: :zone}).order('name')
    end
  end

  def edit
    @sympathizer = Voter.find(params[:id])
  end

  def update
    @sympathizer = Voter.find(params[:id])
    if @sympathizer.add_sympathizer(sympathizer_permit)
      flash.now[:success] = 'Se asigno el simpatizante satisfactoriamente'
      redirect_to admin_sympathizers_path
    else
      flash.now[:danger] = 'Hubo un error al asignar al simpatizante'
      render :new
    end
  end

  def destroy
    @sympathizer = Voter.find(params[:id])
    if @sympathizer.remove_sympathizer
      flash.now[:success] = 'Se removio el simpatizante satisfactoriamente'
      redirect_to admin_sympathizers_path
    else
      flash.now[:danger] = 'Hubo un error al removio al simpatizante'
      render :new
    end
  end

  private
    def sympathizer_permit
      params.require(:sympathizer).permit(:square_id, :promoter_id)
    end

    def get_promoters
      @promoters = Voter.promoters
      @squares = Square.all.includes(section: :zone)
    end

    def search_form
      @q = params[:q] ||= {}
    end
end
