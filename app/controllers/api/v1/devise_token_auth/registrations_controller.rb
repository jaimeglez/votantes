module Api
  module V1
    module DeviseTokenAuth
      class RegistrationsController < ::DeviseTokenAuth::RegistrationsController

        before_action :configure_permitted_parameters, if: :devise_controller?

        def create
          @resource            = resource_class.new(sign_up_params)
          @resource.provider   = "email"

          # honor devise configuration for case_insensitive_keys
          if resource_class.case_insensitive_keys.include?(:email)
            @resource.email = sign_up_params[:email].try :downcase
          else
            @resource.email = sign_up_params[:email]
          end

          # give redirect value from params priority
          @redirect_url = params[:confirm_success_url]

          # fall back to default value if provided
          @redirect_url ||= ::DeviseTokenAuth.default_confirm_success_url

          # success redirect url is required
          if resource_class.devise_modules.include?(:confirmable) && !@redirect_url
            return render_create_error_missing_confirm_success_url
          end

          # if whitelist is set, validate redirect_url against whitelist
          if ::DeviseTokenAuth.redirect_whitelist
            unless ::DeviseTokenAuth::Url.whitelisted?(@redirect_url)
              return render_create_error_redirect_url_not_allowed
            end
          end

          begin
            # override email confirmation, must be sent manually from ctrl
            resource_class.set_callback("create", :after, :send_on_create_confirmation_instructions)
            resource_class.skip_callback("create", :after, :send_on_create_confirmation_instructions)
            if @resource.save
              yield @resource if block_given?

              # unless @resource.confirmed?
              #   # user will require email authentication
              #   @resource.send_confirmation_instructions({
              #     client_config: params[:config_name],
              #     redirect_url: @redirect_url
              #   })
              #
              # else
                # email auth has been bypassed, authenticate user
              @client_id = SecureRandom.urlsafe_base64(nil, false)
              @token     = SecureRandom.urlsafe_base64(nil, false)

              @resource.tokens = @resource.tokens || {}

              @resource.tokens[@client_id] = {
                token: BCrypt::Password.create(@token),
                expiry: (Time.now + ::DeviseTokenAuth.token_lifespan).to_i
              }

              @resource.save!

              # update_auth_header
              # end
              render_create_success
            else
              clean_up_passwords @resource
              render_create_error
            end
          rescue ActiveRecord::RecordNotUnique
            clean_up_passwords @resource
            render_create_error_email_already_exists
          end
        end

        protected

        def configure_permitted_parameters
          devise_parameter_sanitizer.for(:sign_up) << [:full_name, :address, :electoral_number, :section, :created_at, :updated_at, :latitude, :longitude, :phone_number, :social_network, :role, :user_id ]
        end

        # def sign_up_params
        #   params.permit(*params_for_resource(:sign_up) << :full_name << :address << :electoral_number << :section << :created_at << :updated_at << :latitude << :longitude << :phone_number << :social_network << :role << :user_id)
        # end

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
  end
end

