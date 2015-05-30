class Admin::BaseController < ApplicationController
  before_filter :authenticate_user!
  before_filter do
    redirect_to forbidden_path unless current_user.admin?
  end

  layout 'admin'
end
