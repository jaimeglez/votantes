class Admin::AdminBaseController < ApplicationController
  before_filter :authenticate_admin!
end

