class Place::BaseController < ApplicationController
  expose(:place) { current_user.place }

  before_filter :authenticate_user!
  before_filter do
    redirect_to forbidden_path unless current_user.place?
  end

  layout 'admin'
end
