class Admin::TeachersController < Admin::BaseController
  expose(:teacher)

  def index; end

  def show; end

  def update
    teacher.fee = params['teacher']['fee'].to_f
    teacher.save!
    redirect_to :admin_teachers
  end

  def owed_cash
    date = Date.from_dmy(params[:date]) || School.today
    teacher_owed_cash teacher, date
  end

  def transfer_cash_income_money
    teacher.transfer_cash_income_money(params[:amount].gsub('.', '').gsub(',', '.').to_f, Date.from_dmy(params[:date]))
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

  def month_activity
    @date = (begin
      Date.parse(params[:date])
    rescue StandardError
      nil
    end || (School.today.at_beginning_of_month - 1.day)).at_beginning_of_month

    @course_logs = teacher.course_logs.where(date: @date.month_range)
    @tracks = Track.where(id: Course.where(id: @course_logs.select(:course_id)).select(:track_id)).order(:code)
  end

  private

  def order_by_course_log(relation)
    relation.joins(:course_log).order('course_logs.date desc')
  end
end
