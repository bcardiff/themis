module TeacherCashIncomes
  class NewCardIncome < StudentCourseLogIncome
    FEE = 15

    def self.find_or_initialize_by_student_course_log(student_course_log)
      find_or_initialize_by student_course_log: student_course_log do |income|
        income.payment_amount = FEE
      end
    end
  end
end
