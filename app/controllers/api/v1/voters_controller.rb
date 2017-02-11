class Api::V1::VotersController < Api::V1::ApiBaseController
  respond_to :json

  def index
    voters = Voter.all
    respond_with(voters)
  end

  def new
    voter = Voter.new
  end

  def create
    voter = Voter.new(voter_permit)

    if voter.save
      render json: {
        status: 200,
        message: 'Successfully voter added',
        voter: voter
      }.to_json
    else
      render json: {
        status: 400,
        message: 'Something went wrong'
      }.to_json
    end

  end

  def show
    voter = Voter.find(params[:id])
    respond_with(voter)
  end

  def edit
    voter = Voter.find(params[:id])
    respond_with(voter)
  end

  def update
    voter = Voter.find(params[:id])

    if voter.update(voter_permit)
      puts 'display successful message'
    else
      puts 'display error logs'
    end
  end

  def destroy
    voter = Voter.find(params[:id])

    if voter.destroy
      puts 'display successful message'
    else
      puts 'display error logs'
    end
  end

  private
  def voter_permit
    params.require(:voter).permit(
      :full_name,
      :address,
      :electoral_number,
      :section,
      :latitude,
      :longitude,
      :phone_number,
      :social_network,
      :role,
      :email,
      :password,
      :imported,
      :user_id
    )
  end
end
