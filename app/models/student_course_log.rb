class StudentCourseLog < ActiveRecord::Base
  belongs_to :student
  belongs_to :course_log
  belongs_to :teacher
  serialize :payload, JSON

  validates_presence_of :student, :course_log
  validate :validate_teacher_in_course_log

  def validate_teacher_in_course_log
    return unless teacher && course_log

    errors.add(:teacher, 'must be in the course_log') unless course_log.teachers.include?(teacher)
  end
end
