class School
  def self.description
    "Swing City"
  end

  def self.course_incomes_per_month(time)
    StudentCourseLog.handed_at_month(time).sum(:payment_amount)
  end

  def self.course_incomes_not_handed
    StudentCourseLog.owed.sum(:payment_amount)
  end

  def self.course_teaching_expense_per_month(time)
    TeacherCourseLog.paid_at_month(time).sum(:paid_amount)
  end

  def self.course_teaching_expense_to_paid
    TeacherCourseLog.due.joins(:teacher).sum('teachers.fee')
  end
end
