class Teacher < ActiveRecord::Base
  has_many :teacher_course_logs
  has_many :student_course_logs

  def classes_money_owed
    student_course_logs.owed.sum(:payment_amount)
  end
end
