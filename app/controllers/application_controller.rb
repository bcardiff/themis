class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
=begin 
  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end
=end
  protected

  def teacher_owed_cash(teacher, date = School.today)
    @date = date.to_dmy
    incomes = teacher.owed_cash(date)
    @incomes = incomes.to_a.group_by { |e| [e.date, e.course_log_id, e.type] } # TODO: sort
    @total = incomes.sum(:payment_amount)
  end

  def room_signed?
    session[:room_token] == Settings.room_password
  end

  def sign_in_as_room!
    session[:room_token] = Settings.room_password
  end

  def date_or_today
    Date.from_dmy(params[:date]) || School.today
  end
end
