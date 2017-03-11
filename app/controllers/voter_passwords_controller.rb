class VoterPasswordsController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Devise::Controllers::Helpers
  layout 'devise_token'
  def edit
    @voter = Voter.find_by(id: params[:voter])
    if !@voter
      flash.now[:danger] = 'Su token expiró o el usuario no se encontró'
      redirect_to voter_passwords_not_found_path
    end
  end

  def update
    @voter = Voter.find_by(id: resource_params[:id], reset_password_token: resource_params[:reset_password_token])
    if @voter and @voter.id
      @voter.password = resource_params[:password]
      @voter.password_confirmation = resource_params[:password_confirmation]
      if @voter.valid?
        @voter.update_attributes(password: resource_params[:password], password_confirmation: resource_params[:password_confirmation])
        flash.now[:success] = 'Se actualizó tu contraseña satisfactoriamente'
        redirect_to voter_passwords_success_path
      else
        render :edit
      end
    end
  end

  private

  def resource_params
    params.require(:voter).permit(:id, :email, :password, :password_confirmation, :current_password, :reset_password_token, :redirect_url, :config)
  end

end

