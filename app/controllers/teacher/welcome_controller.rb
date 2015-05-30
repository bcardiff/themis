class Teacher::WelcomeController < Teacher::BaseController
  expose(:teacher) { current_user.teacher }

  def index
    start_date = Date.parse(params['start_date']) rescue Date.today

    @course_payments_not_handed = teacher.owed_student_payments
    @handed_course_payments_in_month = teacher.handed_course_payments_per_month(start_date)

    @course_logs = School.course_logs_per_month_grouped(teacher.course_logs, start_date)
    @teaching_expense_in_month = teacher.course_teaching_expense_per_month(start_date)
  end

  def how_to
  end
end
