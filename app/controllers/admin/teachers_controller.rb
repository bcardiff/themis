class Admin::TeachersController < Admin::BaseController
  expose(:teacher)

  def index
  end

  def show
  end

  def owed_cash
    @incomes = teacher.owed_cash.to_a.group_by { |e| [e.date, e.course_log_id, e.type] }

    @total = teacher.owed_cash_total
  end

  def transfer_cash_income_money
    teacher.transfer_cash_income_money
    redirect_to admin_teacher_path(teacher)
  end

  def due_course_salary
    @due_teacher_course_logs = order_by_course_log(teacher.teacher_course_logs.due)

    @due_salary = teacher.due_salary
  end

  def pay_pending_classes
    teacher.pay_pending_classes
    redirect_to admin_teacher_path(teacher)
  end

  private

  def order_by_course_log(relation)
    relation.joins(:course_log).order('course_logs.date desc')
  end
end
