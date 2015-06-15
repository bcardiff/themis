class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  protected

  def teacher_owed_cash(teacher)
    @incomes = teacher.owed_cash.to_a.group_by { |e| [e.date, e.course_log_id, e.type] }
    @total = teacher.owed_cash_total
  end
end
