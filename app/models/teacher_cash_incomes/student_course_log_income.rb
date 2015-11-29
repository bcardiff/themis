module TeacherCashIncomes
  class StudentCourseLogIncome < ::TeacherCashIncome
    belongs_to :student
    belongs_to :student_course_log
    belongs_to :course_log

    before_validation do
      if self.student_course_log
        self.course_log = self.student_course_log.course_log
        self.teacher = self.student_course_log.teacher
        self.date = self.student_course_log.course_log.date
        self.student = student_course_log.student
      end
    end
  end
end
