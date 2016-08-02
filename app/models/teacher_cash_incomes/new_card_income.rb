module TeacherCashIncomes
  class NewCardIncome < StudentCourseLogIncome
    FEE = 30

    def self.find_or_initialize_by_student_course_log(student_course_log)
      find_or_initialize_by student_course_log: student_course_log do |income|
        income.payment_amount = FEE
      end
    end

    def self.create_cashier_card_payment!(teacher, student, date)
      create!(teacher: teacher, date: date, student: student, payment_amount: FEE)
    end

    def kind_description
      "Nueva tarjeta"
    end
  end
end
