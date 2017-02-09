class Api::V1::VotersController < ApplicationController
  respond_to :json

  def index
    @voters = Voter.all
    respond_with(@voters)
  end

  def new
    @voter = Voter.new
  end

  def create
    @voter = Voter.new(voter_permit)

    if @voter.save
      puts 'display successful message'
    else
      puts 'display error logs'
    end

  end

  def show
    @voter = Voter.find(params[:id])
  end

  def edit
    @voter = Voter.find(params[:id])
  end

  def update
    @voter = Voter.find(params[:id])

    if @voter.update(voter_permit)
      puts 'display successful message'
    else
      puts 'display error logs'
    end
  end

  def destroy
    @voter = Voter.find(params[:id])

    if @voter.destroy
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
      :imported,
      :user_id
    )
  end
end
