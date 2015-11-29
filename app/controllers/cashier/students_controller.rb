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

  def show
    render 'admin/students/show'
  end

  def create
    if student.save
      render json: {status: :ok, student: student_json(student)}
    else
      render json: {status: :error, student: student_json(student)}
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
    TeacherCashIncomes::StudentPaymentIncome.create_cashier_pack_payment!(current_user.teacher, student, Date.today, payment_plan)

    render json: {status: :ok, student: student_json(student)}
  end

  private

  def student_params
    params.require(:student).permit(:first_name, :last_name, :email, :card_code)
  end

  def student_json(student)
    {
      id: student.id,
      card_code: student.card_code,
      first_name: student.first_name,
      last_name: student.last_name,
      email: student.email,
    }.tap do |hash|
      hash[:errors] = student.errors.to_hash unless student.valid?

      if student.persisted?
        hash[:pending_payments] = {
          this_month: student.pending_payments_count(Date.today.month_range),
          total: student.pending_payments_count
        }

        hash[:today_pending_classes] = student.student_course_logs.missing_payment.joins(:course_log).between(Date.today).map do |student_course_log|
          {
            id: student_course_log.id,
            course: student_course_log.course_log.course.code
          }
        end
      end
    end
  end
end
