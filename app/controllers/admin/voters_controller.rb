class Admin::VotersController < Admin::AdminBaseController

  def index
    search = params[:search]

    @voters = Voter.active
    if(search)
      @voters = @voters.where("lower(full_name) LIKE ?", "%#{search[:query]}%") if search[:query].present?
      @voters = @voters.per_role(search[:role]) if search[:role].present?
    end
    @voters = @voters.page(params[:page]).per(10)
  end

end
