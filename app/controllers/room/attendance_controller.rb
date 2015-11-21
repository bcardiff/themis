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
    @course_log = CourseLog.find(params[:id])
    @teachers = Teacher.all.order(:name)
  end

  def choose_teachers_post
    course_log = CourseLog.find(params[:id])

    to_remove = course_log.teachers.map(&:id)

    params[:teacher].map(&:to_i).each do |teacher_id|
      course_log.add_teacher(Teacher.find(teacher_id).name)
      to_remove.delete(teacher_id)
    end

    to_remove.each do |teacher_id|
      teacher_course_log = course_log.teacher_course_logs.where(teacher_id: teacher_id).first
      if teacher_course_log.student_course_logs.count == 0
        teacher_course_log.delete
      end
    end

    redirect_to room_students_path(course_log)
  end

  def students
    @course_log = CourseLog.find(params[:id])
  end
end
