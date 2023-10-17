class Teacher::WelcomeController < Teacher::BaseController
  def index
    start_date = begin
      Date.parse(params['start_date'])
    rescue StandardError
      School.today
    end

    @cash_not_handed = teacher.owed_cash_total
    @handed_course_payments_in_month = teacher.handed_course_payments_per_month(start_date)

    @course_logs = School.course_logs_per_month_grouped(teacher.course_logs, start_date)
    @teaching_expense_in_month = teacher.course_teaching_expense_per_month(start_date)
  end

  def owed_cash
    teacher_owed_cash teacher
  end

  def how_to; end

  def venue_rent
    payment_params = params.require(:teacher_cash_incomes_venue_rent).permit(:payment_amount, :description)
    TeacherCashIncomes::VenueRent.create_venue_rent_payment!(teacher, School.today,
                                                             payment_params[:payment_amount].to_i, payment_params[:description])
    redirect_to params[:next_url]
  end
end
