module Api
  module V1
    module DeviseTokenAuth
      class SessionsController < ::DeviseTokenAuth::SessionsController

        swagger_controller :sessions, "Sessions"

        swagger_api :create do
          summary "Create a new session for a user"
          param :form, :email, :string, :required, "Email"
          param :form, :password, :string, :required, "Password"
          response :unauthorized
          response :not_acceptable
        end

      end
    end
  end
end
