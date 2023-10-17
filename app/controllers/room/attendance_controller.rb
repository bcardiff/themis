class Room::AttendanceController < Room::BaseController
  def choose_place
    @places = Place.active.all
    redirect_to room_choose_course_path(@places.first) if @places.size == 1
  end

  def choose_course
    @place = Place.find(params[:place_id])
    @date = begin
      Date.parse(params[:date])
    rescue StandardError
      School.today
    end
    @courses = Course.where(place: @place).ongoing(@date).all.sort_by { |c| [c.start_time, c.track.code] }

    @prev_date = @date - 1.day
    @next_date = @date < School.today ? @date + 1.day : nil
  end

  def open
    date = Date.parse(params[:date])
    course = Course.find(params[:course_id])
    @place = course.place
    course_log = CourseLog.for_course_on_date(course.code, date)

    redirect_to room_choose_teachers_path(course_log)
  end

  def choose_teachers
    @course_log = CourseLog.find(params[:id])
    @place = @course_log.course.place
    @teachers = Teacher.for_classes
  end

  def choose_teachers_post
    course_log = CourseLog.find(params[:id])
    teacher_ids = params[:teacher].map(&:to_i)

    to_remove = course_log.teachers.map(&:id)

    teacher_ids.each do |teacher_id|
      course_log.add_teacher(Teacher.find(teacher_id).name)
      to_remove.delete(teacher_id)
    end

    to_remove.each do |teacher_id|
      teacher_course_log = course_log.teacher_course_logs.where(teacher_id: teacher_id).first
      teacher_course_log.delete if teacher_course_log.student_course_logs.count.zero?
    end

    respond_to do |format|
      format.html do
        redirect_to room_students_path(course_log)
      end
      format.json do
        render json: course_log_teachers_json(course_log)
      end
    end
  end

  def students
    @course_log = CourseLog.find(params[:id])
    @place = @course_log.course.place
    @course_log_json = course_log_json(@course_log)
  end

  def search_student
    @course_log = CourseLog.find(params[:id])
    student = Student.find_by_card(params[:q])
    render json: { student: student_json(@course_log, student, true) }
  end

  def add_student
    course_log = CourseLog.find(params[:id])
    as_helper = params[:as_helper] == 'true'

    student = find_student(params)
    student_log = course_log.student_course_logs.first_or_build(student: student)
    student_log.id_kind = student.card_code.blank? ? 'guest' : 'existing_card'
    student_log.payment_plan = nil
    student_log.as_helper = as_helper
    student_log.save!

    render json: { course_log: course_log_json(course_log) }
  end

  def remove_student
    course_log = CourseLog.find(params[:id])

    student = find_student(params)
    student_log = course_log.student_course_logs.where(student: student).first
    # TODO: show error if unable to delete the student due to existing payment information
    # for this class
    if student_log.payment_plan.nil?
      student_log.destroy!
    else
      logger.warn "Unable to delete student due to existing payment information #{student_log.inspect}"
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
    course_log.untracked_students_count -= 1 if course_log.untracked_students_count > 0
    course_log.save!
    render json: { course_log: course_log_json(course_log) }
  end

  private

  def find_student(params)
    if params[:card_code]
      Student.find_by_card(params[:card_code])
    else
      Student.find(params[:student_id])
    end
  end

  def student_json(course_log, student, requires_pack)
    return nil unless student

    pending_payment = student.student_course_logs.missing_payment.count > 0

    pending_payment = student.student_packs.valid_for_course_log(course_log).find { |p| p.available_courses > 0 }.nil? if !pending_payment && requires_pack

    {
      card_code: student.card_code,
      first_name: student.first_name,
      last_name: student.last_name,
      email: student.email,
      pending_payment: pending_payment
    }
  end

  def course_log_json(course_log)
    {
      id: course_log.id,
      teachers: course_log_teachers_json(course_log),
      students: course_log.student_course_logs.joins(:student)
        .order('students.first_name, students.last_name').map do |s|
                  student_json(course_log, s.student, false).tap do |sj|
                    sj[:as_helper] = s.as_helper
                  end
                end,
      total_students: course_log.students_count,
      untracked_students_count: course_log.untracked_students_count
    }
  end

  def course_log_teachers_json(course_log)
    course_log.teachers.order(:name).to_a.map { |t| { id: t.id, name: t.name } }
  end
end
