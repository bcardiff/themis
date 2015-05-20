class Admin::WelcomeController < Admin::BaseController
  def index
    CourseLog.fill_missings

    start_date = Date.parse(params['start_date']) rescue Date.today
    @course_logs = CourseLog.where(date: start_date.beginning_of_month..start_date.end_of_month).all.group_by(&:date)
  end
end
