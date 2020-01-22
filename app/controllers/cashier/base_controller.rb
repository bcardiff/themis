class Cashier::BaseController < ApplicationController
  expose(:cashier) { current_user.teacher }
  expose(:place) { Place.find(params[:place_id]) }

  before_filter :authenticate_user!
  before_filter do
    redirect_to forbidden_path unless current_user.cashier?
  end

  layout 'admin'
end
