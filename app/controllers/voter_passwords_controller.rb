class VoterPasswordsController < ApplicationController
  def edit
    @voter = Voter.find(params[:voter])
  end
end

