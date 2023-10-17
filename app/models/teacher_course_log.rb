class TeacherCourseLog < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :course_log

  scope :due, -> { where(paid: false) }
  scope :due_up_to, ->(date) { due.joins(:course_log).where('course_logs.date <= ?', date) }
  scope :paid, -> { where(paid: true) }
  scope :paid_at_month, lambda { |time|
                          paid.where('paid_at >= ?', time.at_beginning_of_month).where('paid_at < ?', time.at_beginning_of_month.next_month)
                        }

  def student_course_logs
    course_log.student_course_logs.where(teacher: teacher)
  end

  def course
    course_log.course
  end
end
