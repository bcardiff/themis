class Admin::WelcomeController < Admin::BaseController
  def index
    CourseLog.fill_missings

    start_date = Date.parse(params['start_date']) rescue Date.today
    @course_logs = CourseLog.where(date: start_date.beginning_of_month..start_date.end_of_month).all.group_by(&:date)

    @course_incomes_not_handed = School.course_incomes_not_handed
    @course_incomes_in_month = School.course_incomes_per_month(start_date)


    @course_teaching_expense_to_paid = School.course_teaching_expense_to_paid
    @course_teaching_expense_in_month = School.course_teaching_expense_per_month(start_date)
  end

  def student_payments
  end

  def teacher_courses
  end
end
