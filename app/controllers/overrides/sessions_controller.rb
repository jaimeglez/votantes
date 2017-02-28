module Overrides
  class SessionsController < DeviseTokenAuth::SessionsController

    swagger_controller :sessions, "Sessions"

    swagger_api :create do
      summary "Create a new session for a user"
      param :form, :email, :string, :required, "Email"
      param :form, :password, :string, :required, "Password"
      response :unauthorized
      response :not_acceptable
    end

    swagger_api :destroy do
      summary "Remove session for a user"
      param :header, :uid, :string, :required, "Email"
      param :header, :client, :string, :required, "Client"
      param :header, :access_token, :string, :required, "Access token"
      response :unauthorized
      response :not_acceptable
    end

  end
end
