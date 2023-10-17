class Cashier::DashboardController < Cashier::BaseController
  def index; end

  def calendar
    start_date = begin
      Date.parse(params['start_date'])
    rescue StandardError
      School.today
    end
    month = start_date.calendar_range

    @dates_with_attention_required = Set.new
    CourseLog.where(date: month).at_place(place).cashier_attention_required_untracked.select('distinct date').pluck(:date).each do |d|
      @dates_with_attention_required << d
    end
    CourseLog.where(date: month).at_place(place).cashier_attention_required_missing_payment.select('distinct date').pluck(:date).each do |d|
      @dates_with_attention_required << d
    end
  end

  def owed_cash
    teacher_owed_cash current_user.teacher
  end

  def open_course
    date = Date.from_dmy(params[:date])
    @course_log = CourseLog.for_course_on_date(params[:course], date)

    render json: status_json(date)
  end

  def status
    date = date_or_today

    render json: status_json(date)
  end

  def status_json(date)
    courses = Course.ongoing(date).where(place_id: place.id).order(:start_time)

    {
      owed_cash_total: current_user.teacher.owed_cash_total.to_i,
      courses: courses.map do |course|
        cashier_course_json(CourseLog.find_or_initialize_by(course: course, date: date))
      end
    }
  end

  def cashier_course_json(course_log)
    { course: course_log.course.code,
      description: course_log.course.description(:track),
      start_time: course_log.course.start_time.to_s(:time),
      students_count: course_log.students_count,
      started: course_log.persisted?,
      attention_required: course_log.untracked_students_count > 0 || StudentCourseLog.where(student_id: course_log.students.pluck(:id)).missing_payment.count > 0 }
  end
end
