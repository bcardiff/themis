class Admin::WelcomeController < Admin::BaseController
  include ApplicationHelper

  def index
    CourseLog.fill_missings

    start_date = Date.parse(params['start_date']) rescue Date.today
    @course_logs = School.course_logs_per_month_grouped(CourseLog, start_date)

    @course_incomes_not_handed = School.course_incomes_not_handed
    @course_incomes_in_month = School.course_incomes_per_month(start_date)


    @course_teaching_expense_to_paid = School.course_teaching_expense_to_paid
    @course_teaching_expense_in_month = School.course_teaching_expense_per_month(start_date)
  end

  def teacher_cash_incomes
  end

  def teacher_courses
  end

  def horarios_wp
  end

  def balance
    @categories = []
    @periods = []
    @balance_cell = {}

    incomes = TeacherCashIncome.select("type as kind, year(date) as year, month(date) as month, SUM(payment_amount) as amount")
      .group("type, year(date), month(date)")
    incomes.each do |income|
      period = "#{income["year"]}-#{"%02d" % income["month"]}"
      category = income["kind"]
      @categories << category
      @periods << period

      @balance_cell[period] ||= {}
      @balance_cell[period][category] = income["amount"]
    end

    expenses = TeacherCourseLog.paid.joins(:course_log)
      .select("year(course_logs.date) as year, month(course_logs.date) as month, SUM(paid_amount) as amount")
      .group("year(date), month(date)")
    expenses.each do |expense|
      next unless expense["amount"]
      period = "#{expense["year"]}-#{"%02d" % expense["month"]}"
      category = "TeacherPayment"
      @categories << category
      @periods << period

      @balance_cell[period] ||= {}
      @balance_cell[period][category] = - expense["amount"]
    end

    expenses = TeacherCourseLog.due.joins(:teacher).joins(:course_log)
      .select("year(course_logs.date) as year, month(course_logs.date) as month, SUM(teachers.fee) as amount")
      .group("year(date), month(date)")
    expenses.each do |expense|
      next unless expense["amount"]
      period = "#{expense["year"]}-#{"%02d" % expense["month"]}"
      category = "TeacherOwedPayment"
      @categories << category
      @periods << period

      @balance_cell[period] ||= {}
      @balance_cell[period][category] = - expense["amount"]
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
end
