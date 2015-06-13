class StudentCourseLogTeacherCashIncome < TeacherCashIncome
  belongs_to :student_course_log
  belongs_to :course_log

  delegate :student, to: :student_course_log

  before_create do
    self.course_log = self.student_course_log.course_log
    self.teacher = self.student_course_log.teacher
  end
end
