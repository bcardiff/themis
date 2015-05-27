class School
  def self.course_income_account
    DoubleEntry.account(:course_income)
  end
end
