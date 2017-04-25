class Admin::VotersController < Admin::AdminBaseController

  def index
    search = params[:search]

    @voters = Voter.active
    if(search && search[:query].present?)
      @voters = @voters.where("lower(full_name) LIKE ?", "%#{search[:query]}%")
    end
    @voters = @voters.page(params[:page]).per(10)
  end

end
