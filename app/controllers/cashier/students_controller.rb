class Cashier::StudentsController < Cashier::BaseController
  expose(:student, attributes: :student_params)

  def index
    respond_to do |format|
      format.html
      format.json do
        students = Student.autocomplete(params[:q]).page(params[:page]).per(5)

        render json: {
          total_count: students.total_count,
          items: students.map { |s| student_json(s) },
          next_url: students.last_page? ? nil : cashier_students_path(format: :json, q: params[:q], page: students.next_page)
        }
      end
    end
  end

  def course
    course = Course.find_by(code: params[:course])
    course_log = course.course_logs.find_by(date: date_or_today)

    render json: {
      course_log_id: course_log.id,
      room_name: course.room_name,
      untracked_students_count: course_log.untracked_students_count,
      students: course_log.students.map { |s| student_json(s) }.sort_by { |h| - h[:pending_payments][:this_month] },
    }
  end

  def show
    render 'admin/students/show'
  end

  def create
    if student.save
      unless student.card_code.blank?
        TeacherCashIncomes::NewCardIncome.create_cashier_card_payment!(current_user.teacher, student, School.today)
      end

      begin
        StudentNotifications.welcome(student).deliver_now if student.email.present?
      rescue => ex
        logger.warn ex
      end

      render json: {status: :ok, student: student_json(student)}
    else
      render json: {status: :error, student: student_json(student)}
    end
  end

  def update
    self.student = Student.find(params[:id])
    cards_count = student.cards.count


    begin
      student.first_name = student_params[:first_name]
      student.last_name = student_params[:last_name]
      student.email = student_params[:email]
      student.comment = student_params[:comment]
      student.comment_by = current_user if student.comment_changed?
      student.phone = student_params[:phone]
      student.save!

      student.update_as_new_card! student_params[:first_name], student_params[:last_name], student_params[:email], student_params[:card_code], student_params[:phone]
      if cards_count != student.cards.count
        TeacherCashIncomes::NewCardIncome.create_cashier_card_payment!(current_user.teacher, student, School.today)
        student.card_code = Student.format_card_code(student_params[:card_code])
        student.save(validate: false)
      end

      redirect_to cashier_student_path(student)
    rescue
      render :edit
    end
  end

  def single_class_payment
    student = Student.find(params[:id])
    student_course_log = student.student_course_logs.find(params[:student_course_log_id])
    student_course_log.teacher = current_user.teacher
    student_course_log.payment_plan = PaymentPlan.single_class
    student_course_log.save!

    render json: {status: :ok, student: student_json(student)}
  end

  def pack_payment
    student = Student.find(params[:id])
    payment_plan = PaymentPlan.find_by(code: params[:code])
    TeacherCashIncomes::StudentPaymentIncome.create_cashier_pack_payment!(current_user.teacher, student, School.today, payment_plan)

    render json: {status: :ok, student: student_json(student)}
  end

  def track_in_course_log
    student = Student.find(params[:id])
    course_log = CourseLog.find(params[:course_log_id])

    course_log.student_course_logs.create!({
      student: student,
      payment_plan: nil,
      id_kind: (student.card_code.blank? ? "guest" : "existing_card")
    })

    course_log.untracked_students_count -= 1 # TODO if params[:untracked]
    course_log.save!

    render json: {status: :ok, student: student_json(student)}
  end

  def remove_pack
    student = Student.find(params[:id])
    pack = student.student_packs.find(params[:student_pack_id])
    pack.rollback_payment_and_pack(current_user)

    redirect_to cashier_student_path(student)
  end

  private

  def student_params
    params.require(:student).permit(:first_name, :last_name, :email, :card_code, :known_by, :comment, :phone)
  end

  def student_json(student)
    {
      id: student.id,
      card_code: student.card_code,
      first_name: student.first_name,
      last_name: student.last_name,
      email: student.email,
      comment: student.comment,
      comment_at: student.comment_at.try(&:to_human),
      comment_by: student.comment_by.try(&:name),
      phone: student.phone,
    }.tap do |hash|
      hash[:errors] = student.errors.to_hash unless student.valid?

      if student.persisted?
        hash[:pending_payments] = {
          this_month: student.pending_payments_count(School.today.month_range),
          total: student.pending_payments_count
        }

        hash[:available_courses] = student.student_packs.valid_for(School.today).to_a.sum(&:available_courses)

        hash[:today_pending_classes] = student.student_course_logs.missing_payment.joins(:course_log).between(School.today).map do |student_course_log|
          {
            id: student_course_log.id,
            course: student_course_log.course_log.course.code
          }
        end
      end
    end
  end
end
