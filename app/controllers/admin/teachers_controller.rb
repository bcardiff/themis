class Admin::TeachersController < Admin::BaseController
  expose(:teacher)

  def index
  end

  def show
  end

  def owed_cash
    date = Date.from_dmy(params[:date]) || School.today
    teacher_owed_cash teacher, date
  end

  def transfer_cash_income_money
    teacher.transfer_cash_income_money(params[:amount].gsub('.','').gsub(',','.').to_f, Date.from_dmy(params[:date]))
    redirect_to admin_teacher_path(teacher)
  end

  def due_course_salary
    date = Date.from_dmy(params[:date]) || School.today
    @date = date.to_dmy
    @due_teacher_course_logs = order_by_course_log(teacher.teacher_course_logs.due_up_to(date))

    @due_salary = teacher.due_salary(date)
  end

  def pay_pending_classes
    date = Date.from_dmy(params[:date])
    teacher.pay_pending_classes(date)
    redirect_to admin_teacher_path(teacher)
  end

  private

  def order_by_course_log(relation)
    relation.joins(:course_log).order('course_logs.date desc')
  end
end
