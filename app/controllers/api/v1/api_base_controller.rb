class Api::V1::ApiBaseController < ApplicationController
  include Devise::Controllers::Helpers
  before_action :authenticate_voter!
  protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }
  respond_to :json
end
