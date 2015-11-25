class Cashier::DashboardController < Cashier::BaseController
  def index
    todays_courses = Course.ongoing.includes(:place).where(weekday: Date.today.wday)
    @places = todays_courses.group(:place_id).map{ |c| {id: c.place_id, name: c.place.name} }
    @courses = {}
    todays_courses.each do |course|
      @courses[course.start_time.to_s(:time)] ||= []
      @courses[course.start_time.to_s(:time)] << course
    end
    @courses = @courses.sort
  end

end
