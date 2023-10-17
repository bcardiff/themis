class Admin::WelcomeController < Admin::BaseController
  include ApplicationHelper

  def index
    CourseLog.fill_missings

    @start_date = begin
      Date.parse(params['start_date'])
    rescue StandardError
      School.today
    end
    @course_logs = School.course_logs_per_month_grouped(CourseLog, @start_date)

    @course_incomes_not_handed = School.course_incomes_not_handed
    @course_incomes_in_month = School.course_incomes_per_month(@start_date)

    @course_teaching_expense_to_paid = School.course_teaching_expense_to_paid
    @course_teaching_expense_in_month = School.course_teaching_expense_per_month(@start_date)

    @student_course_logs_missing_payment = StudentCourseLog.joins(:course_log).where(course_logs: { date: @start_date.month_range }).missing_payment.count
    @students_missing_payment = Student.missing_payment(@start_date).count
  end

  def teacher_cash_incomes; end

  def teacher_courses; end

  def horarios_wp; end

  def balance
    @categories = []
    @periods = []
    @balance_cell = {}

    incomes = TeacherCashIncome.select('type as kind, year(date) as year, month(date) as month, SUM(payment_amount) as amount')
      .group('type, year(date), month(date)')
    incomes.each do |income|
      period = format('%<year>s-%<month>02d', year: income['year'], month: income['month'])
      category = income['kind']
      @categories << category
      @periods << period

      @balance_cell[period] ||= {}
      @balance_cell[period][category] = income['amount']
    end

    expenses = TeacherCourseLog.paid.joins(:course_log)
      .select('year(course_logs.date) as year, month(course_logs.date) as month, SUM(paid_amount) as amount')
      .group('year(date), month(date)')
    expenses.each do |expense|
      next unless expense['amount']

      period = format('%<year>s-%<month>02d', year: expense['year'], month: expense['month'])
      category = 'TeacherPayment'
      @categories << category
      @periods << period

      @balance_cell[period] ||= {}
      @balance_cell[period][category] = - expense['amount']
    end

    expenses = TeacherCourseLog.due.joins(:teacher).joins(:course_log)
      .select('year(course_logs.date) as year, month(course_logs.date) as month, SUM(teachers.fee) as amount')
      .group('year(date), month(date)')
    expenses.each do |expense|
      next unless expense['amount']

      period = format('%<year>s-%<month>02d', year: expense['year'], month: expense['month'])
      category = 'TeacherOwedPayment'
      @categories << category
      @periods << period

      @balance_cell[period] ||= {}
      @balance_cell[period][category] = - expense['amount']
    end

    @periods.uniq!.sort!
    @categories.uniq!.sort_by! { |x| human_balance_category(x) }

    @net_income = Hash.new(0)
    @periods.each do |period|
      @categories.each do |category|
        @net_income[period] = @net_income[period] + (@balance_cell[period][category] || 0)
      end
    end
  end

  def missing_payments; end

  def pricing
    @payment_plans = PaymentPlan.updatable_prices

    @fixed_fees = FixedFee.all
  end

  def pricing_update
    @payment_plans = PaymentPlan.updatable_prices
    @fixed_fees = FixedFee.all

    ActiveRecord::Base.transaction do
      begin
        params[:payment_plans].values.each do |entry|
          @payment_plans.select { |p| p.id == entry['id'].to_i }.first.price = entry['price']
        end
        @payment_plans.each(&:save!)

        params[:fixed_fees].values.each do |entry|
          @fixed_fees.select { |p| p.id == entry['id'].to_i }.first.value = entry['value']
        end
        @fixed_fees.each(&:save!)
      rescue StandardError => e
        logger.warn e
        flash.now[:error] = 'Error al actualizar precios'
        render 'pricing'
        return
      end
    end

    flash[:notice] = 'Precios actualizados'
    redirect_to admin_pricing_path
  end
end
