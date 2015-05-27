class Teacher < ActiveRecord::Base
  has_many :teacher_course_logs
  has_many :student_course_logs do
    def transfer_classes_money
      owed.update_all(payment_status: StudentCourseLog::PAYMENT_ON_CLASSES_INCOME)
    end
  end

  def classes_money_owed
    student_course_logs.owed.sum(:payment_amount)
  end

  def transfer_classes_money
    # todo lock/transaction

    # amount = self.classes_money_owed
    student_course_logs.transfer_classes_money
  end
end
