module Overrides
  class PasswordsController < DeviseTokenAuth::PasswordsController

    swagger_controller :passwords, "Passwords"

    swagger_api :create do
      summary "Reset password"
      param :form, :email, :string, :required, "Email"
      param :form, :redirect_url, :string, "Redirect"
      response :unauthorized
      response :not_acceptable
    end

  end
end
