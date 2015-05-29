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
end
