class Cashier::DashboardController < Cashier::BaseController
  def index
  end

  def owed_cash
    teacher_owed_cash current_user.teacher
  end

  def status
    date = Date.today
    courses = Course.ongoing.includes(:place).where(weekday: date.wday).order(:start_time)

    render json: {
      owed_cash_total: current_user.teacher.owed_cash_total.to_i,
      courses: courses.map { |course|
        course_log = CourseLog.find_or_initialize_by(course: course, date: date)
        { course: course.code,
          room_name: course.room_name,
          start_time: course.start_time.to_s(:time),
          students_count: course_log.students_count,
          started: course_log.persisted?,
          attention_required: course_log.untracked_students_count > 0 || StudentCourseLog.where(student_id: course_log.students.pluck(:id)).missing_payment.count > 0
        }
      }
    }
  end
end
