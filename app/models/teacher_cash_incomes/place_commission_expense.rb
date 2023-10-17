module TeacherCashIncomes
  class PlaceCommissionExpense < StudentCourseLogIncome
    belongs_to :place
    validates_presence_of :place

    def self.find_or_initialize_by_student_course_log(student_course_log)
      # find_or_initialize_by student_course_log: student_course_log do |income|
      # end
    end

    def kind_description
      'Comisión sala'
    end

    before_validation do
      self.place = student_course_log.course_log.course.place
    end
  end
end
