class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  protected

  def teacher_owed_cash(teacher, date = Date.today)
    @date = date.to_dmy
    incomes = teacher.owed_cash(date)
    @incomes = incomes.to_a.group_by { |e| [e.date, e.course_log_id, e.type] } # TODO sort
    @total = incomes.sum(:payment_amount)
  end
end
