class Room::AttendanceController < Room::BaseController
  def choose_course
    @date = Date.parse(params[:date]) rescue Date.today
    @courses = Course.ongoing(@date)

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
    @teachers = Teacher.where('priority > 0').order(:priority, :name)
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
    @course_log_json = course_log_json(@course_log)
  end

  def search_student
    @course_log = CourseLog.find(params[:id])
    student = Student.find_by_card(params[:q])
    render json: { student: student_json(@course_log, student, true) }
  end

  def add_student
    course_log = CourseLog.find(params[:id])

    student = Student.find_by_card(params[:card_code])
    student_log = course_log.student_course_logs.first_or_build(student: student)
    student_log.id_kind = "existing_card"
    student_log.payment_plan = nil
    student_log.save!

    render json: { course_log: course_log_json(course_log) }
  end

  def remove_student
    course_log = CourseLog.find(params[:id])

    student = Student.find_by_card(params[:card_code])
    student_log = course_log.student_course_logs.where(student: student).first
    # TODO show error if unable to delete the student due to existing payment information
    # for this class
    if student_log.payment_plan.nil?
      student_log.destroy!
    end

    render json: { course_log: course_log_json(course_log) }
  end

  def add_students_no_card
    course_log = CourseLog.find(params[:id])
    course_log.untracked_students_count += 1
    course_log.save!
    render json: { course_log: course_log_json(course_log) }
  end

  def remove_students_no_card
    course_log = CourseLog.find(params[:id])
    if course_log.untracked_students_count > 0
      course_log.untracked_students_count -= 1
    end
    course_log.save!
    render json: { course_log: course_log_json(course_log) }
  end

  private

  def student_json(course_log, student, using_pack)
    return nil unless student

    pending_payment = student.student_course_logs.missing_payment.count > 0

    if !pending_payment && using_pack
      pending_payment = student.student_packs.valid_for(course_log.date).find { |p| p.available_courses > 0 }.nil?
    end

    return {
      card_code: student.card_code,
      first_name: student.first_name,
      last_name: student.last_name,
      email: student.email,
      pending_payment: pending_payment
    }
  end

  def course_log_json(course_log)
    return {
      id: course_log.id,
      teachers: course_log.teachers.map(&:name),
      students: course_log.students.order(:first_name, :last_name).map { |s| student_json(course_log, s, false) } ,
      total_students: course_log.students_count,
      untracked_students_count: course_log.untracked_students_count
    }
  end
end
