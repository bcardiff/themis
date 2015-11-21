class Room::AttendanceController < Room::BaseController
  def choose_course
    @date = Date.parse(params[:date]) rescue Date.today
    @courses = Course.ongoing.where(weekday: @date.wday)

    @prev_date = @date - 1.day
    @next_date = @date < Date.today ? @date + 1.day : nil
  end

  def open
    date = Date.parse(params[:date])
    course = Course.find(params[:course_id])

    course_log = CourseLog.for_course_on_date(course.code, date)

    redirect_to room_choose_teachers_path(course_log)
  end

  def choose_teachers
  end
end
