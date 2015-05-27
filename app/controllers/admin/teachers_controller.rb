class Admin::TeachersController < Admin::BaseController
  expose(:teacher)

  def index
  end

  def show
  end

  def owed_student_payments
    @payments = teacher.student_course_logs.owed.to_a.group_by(&:course_log)

    @total = teacher.owed_student_payments
  end

  def transfer_student_payments_money
    teacher.transfer_student_payments_money
    redirect_to admin_teacher_path(teacher)
  end
end
