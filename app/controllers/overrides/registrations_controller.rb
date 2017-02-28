module Overrides
  class RegistrationsController < DeviseTokenAuth::RegistrationsController

    swagger_controller :registrations, "Registrations"

    swagger_api :create do
      summary "Creates a new User"
      param :form, :full_name, :required, "Full name"
      param :form, :address, :required, "Address"
      param :form, :electoral_number, :required, "Electoral number"
      param :form, :latitude, :required, "Latitude"
      param :form, :longitude, :required, "Longitude"
      param :form, :phone_number, :required, "Phone number"
      param :form, :social_network, :required, "Social network"
      param :form, :role, :required, "Role"
      param :form, :user_id, :required, "User"
      param :form, :section, :required, "Seccion"
      param :form, :email, :string, :required, "Email address"
      param :form, :password, :string, :required, "Password"
      param :form, :password_confirmation, :string, :required, "Password Confirmation"
      response :unauthorized
      response :not_acceptable
    end

  end
end
