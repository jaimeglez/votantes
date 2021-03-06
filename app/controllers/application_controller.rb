class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }
  before_action :configure_permitted_parameters, if: :devise_controller?

  def redirect_to(*args)
    flash.keep
    super
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :address, :electoral_number, :section, :latitude, :longitude, :phone_number, :social_network, :role, :user_id ])
  end

end
