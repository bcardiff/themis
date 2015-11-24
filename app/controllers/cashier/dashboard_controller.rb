class Cashier::DashboardController < Cashier::BaseController
  def index
    courses = Course.ongoing.where(weekday: Date.today.wday)
    @courses_by_time = {}
    courses.each do |course|
      @courses_by_time[course.start_time] ||= []
      @courses_by_time[course.start_time] << course
    end
    @courses_by_time = @courses_by_time.sort
  end

end
