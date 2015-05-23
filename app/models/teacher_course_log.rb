class TeacherCourseLog < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :course_log

  def student_course_logs
    course_log.student_course_logs.where(teacher: teacher)
  end

  def course
    course_log.course
  end
end
