class Admin::WelcomeController < Admin::BaseController
  def index
    CourseLog.fill_missings
  end
end
