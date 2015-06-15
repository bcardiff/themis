class Teacher::BaseController < ApplicationController
  expose(:teacher) { current_user.teacher }

  before_filter :authenticate_user!
  before_filter do
    redirect_to forbidden_path unless current_user.teacher?
  end

  layout 'admin'
end
