module TeacherCashIncomes
  class StudentPaymentIncome < StudentCourseLogIncome
    def self.find_or_initialize_by_student_course_log(student_course_log)
      find_or_initialize_by student_course_log: student_course_log do |income|
      end
    end

    def kind_description
      "Pago de alumno"
    end
  end
end
