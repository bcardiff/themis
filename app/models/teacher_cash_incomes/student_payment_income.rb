module TeacherCashIncomes
  class StudentPaymentIncome < StudentCourseLogIncome
    def self.find_or_initialize_by_student_course_log(student_course_log)
      find_or_initialize_by student_course_log: student_course_log do |income|
      end
    end

    def kind_description
      "Pago de alumno"
    end

    before_save do
      place = student_course_log.course_log.course.place
      if place
        place.after_payment(self)
      end
    end

    before_destroy do
      place = student_course_log.course_log.course.place
      if place
        place.after_payment_destroy(self)
      end
    end
  end
end
