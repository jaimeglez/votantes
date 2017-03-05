class Api::V1::ApiBaseController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Devise::Controllers::Helpers
  protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }
  respond_to :json
end
