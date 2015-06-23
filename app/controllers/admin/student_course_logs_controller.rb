class Admin::StudentCourseLogsController < Admin::BaseController
  expose(:course_log)
  expose(:student_course_log, attributes: :student_course_log_params)

  def create
    course_log.missing = false
    course_log.save!

    ensure_student_course_log_params

    @new_student_course_log = student_course_log

    if student_course_log.save
      redirect_to [:admin, course_log]
    else
      render 'admin/course_logs/show'
    end
  end

  def update
    ensure_student_course_log_params

    if student_course_log.save
      redirect_to [:admin, course_log]
    else
      render 'edit'
    end
  end

  private

  def ensure_student_course_log_params
    course_log.add_teacher(student_course_log.teacher.try(:name))

    student_course_log.course_log = course_log
    if student_course_log.payment_plan
      student_course_log.payment_amount = student_course_log.payment_plan.price_or_fallback(student_course_log.payment_amount)
    end
  end

  def student_course_log_params
    params.require(:student_course_log).permit(:id_kind, :student_id, :student, :teacher_id, :teacher, :payment_plan_id, :payment_plan, :payment_amount).slice(:id_kind, :student_id, :teacher_id, :payment_plan_id, :payment_amount)
  end
end
