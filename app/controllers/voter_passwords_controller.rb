class VoterPasswordsController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Devise::Controllers::Helpers
  def edit
    @voter = Voter.find(params[:voter])
  end

  def update
    @voter = Voter.find_by(id: resource_params[:id], reset_password_token: resource_params[:reset_password_token])
    if @voter and @voter.id
      @voter.update_attributes(password: resource_params[:password], password_confirmation: resource_params[:password_confirmation])
    end
  end

  private

  def resource_params
    params.require(:voter).permit(:id, :email, :password, :password_confirmation, :current_password, :reset_password_token, :redirect_url, :config)
  end

end

