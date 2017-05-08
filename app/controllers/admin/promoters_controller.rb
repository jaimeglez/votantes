class Admin::PromotersController < ApplicationController
  before_action :search_form, only: :index
  before_filter :get_squares, only: [:index, :new, :edit]

  def index
    if params[:q].present?
      @promoters = Voter.build_search(params[:q]).order('name asc')
    else
      @promoters = Voter.promoters.order('full_name')
    end
  end

  def new
    @promoters = Voter.sympathizers
  end

  def create
    @promoter = Voter.find(params[:promoter][:voter_id])
    if @promoter.add_promoter(promoter_permit)
      flash.now[:success] = 'Se creó el promotor satisfactoriamente'
      redirect_to admin_promoters_path
    else
      flash.now[:danger] = 'Hubo un error al crear al promotor'
      render :new
    end
  end

  def show
    @square = Square.find(params[:id])
  end

  def destroy
    @promoter = Voter.find(params[:id])
    if @promoter.remove_promoter
      flash.now[:success] = 'Se creó el promotor satisfactoriamente'
      redirect_to admin_promoters_path
    else
      flash.now[:danger] = 'Hubo un error al crear al promotor'
      render :new
    end
  end

  private
    def promoter_permit
      params.require(:promoter).permit(:square_id)
    end

    def get_squares
      @squares = Square.active.includes(section: :zone)
    end

    def search_form
      @q = params[:q] ||= {}
    end
end
