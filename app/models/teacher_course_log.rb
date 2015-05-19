class TeacherCourseLog < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :course_log

  def course
    course_log.course
  end
end
