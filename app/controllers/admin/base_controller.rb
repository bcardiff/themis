class Admin::BaseController < ApplicationController
  before_filter :authenticate_user!
  before_filter :only_admin

  def only_admin
    redirect_to forbidden_path unless current_user.admin?
  end

  def only_admin_or_cashier
    redirect_to forbidden_path unless current_user.admin? || current_user.cashier?
  end

  layout 'admin'
end
