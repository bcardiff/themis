class WelcomeController < ApplicationController
  def index
    return unless current_user

    if current_user.admin?
      redirect_to admin_index_url
    elsif current_user.cashier?
      redirect_to cashier_dashboard_url(Place.default)
    elsif current_user.teacher?
      redirect_to teacher_index_url
    elsif current_user.place?
      redirect_to place_index_url
    end
  end

  def forbidden; end
end
