class School
  def self.description
    'Swing City'
  end

  def self.weekdays
    [1, 2, 3, 4, 5, 6, 0]
  end

  def self.today
    Time.zone.today
  end

  def self.course_incomes_per_month(time)
    TeacherCashIncome.handed_at_month(time).sum(:payment_amount)
  end

  def self.course_incomes_not_handed
    TeacherCashIncome.owed.sum(:payment_amount)
  end

  def self.course_teaching_expense_per_month(time)
    TeacherCourseLog.paid_at_month(time).sum(:paid_amount)
  end

  def self.course_teaching_expense_to_paid
    TeacherCourseLog.due.joins(:teacher).sum('teachers.fee')
  end

  def self.course_logs_per_month_grouped(course_logs, date)
    course_logs.where(date: date.beginning_of_month..date.end_of_month).all.group_by(&:date)
  end
end
