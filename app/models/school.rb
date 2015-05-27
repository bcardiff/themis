class School
  def self.description
    "Swing City"
  end

  def self.course_incomes_total
    StudentCourseLog.handed.sum(:payment_amount)
  end

  def self.course_incomes_not_handed
    StudentCourseLog.owed.sum(:payment_amount)
  end
end
