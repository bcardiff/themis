class Admin::StudentCourseLogsController < Admin::BaseController
  expose(:course_log)
  expose(:student_course_log, attributes: :student_course_log_params)

  def create
    course_log.missing = false
    course_log.save!

    case student_course_log.id_kind
    when 'new_card'
      student_data = params[:student_course_log][:student]

      student_course_log.student = Student.find_or_initialize_by_card student_data[:card_code]
      student_course_log.student.update_as_new_card!(student_data[:first_name], student_data[:last_name],
                                                     student_data[:email], student_data[:card_code])
    when 'existing_card'
      # student is referenced by id
    when 'guest'
      student_data = params[:student_course_log][:student]
      student_course_log.student = Student.find_or_initialize_by_email student_data[:email]
      student_course_log.student.update_as_guest!(student_data[:first_name], student_data[:last_name])
    end

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

  def destroy
    if student_course_log.destroy
      redirect_to [:admin, course_log]
    else
      render 'edit'
    end
  end

  private

  def ensure_student_course_log_params
    course_log.add_teacher(student_course_log.teacher.try(:name))

    student_course_log.course_log = course_log
    return unless student_course_log.payment_plan

    student_course_log.payment_amount = student_course_log.payment_plan.price_or_fallback(student_course_log.payment_amount)
  end

  def student_course_log_params
    params.require(:student_course_log).permit(:id_kind, :student_id, :student, :teacher_id, :teacher, :payment_plan_id, :payment_plan, :payment_amount).slice(
      :id_kind, :student_id, :teacher_id, :payment_plan_id, :payment_amount
    )
  end
end
