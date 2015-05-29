class Teacher < ActiveRecord::Base
  validates_numericality_of :fee

  has_many :teacher_course_logs
  has_many :student_course_logs do
    def transfer_student_payments_money
      owed.update_all(payment_status: StudentCourseLog::PAYMENT_ON_CLASSES_INCOME, transferred_at: Time.now)
    end
  end

  def owed_student_payments
    student_course_logs.owed.sum(:payment_amount)
  end

  def transfer_student_payments_money
    amount = self.owed_student_payments

    student_course_logs.transfer_student_payments_money
  end

  def due_salary
    teacher_course_logs.due.count * fee
  end

  def pay_pending_classes
    teacher_course_logs.due.update_all(paid: true, paid_at: Time.now, paid_amount: fee)
  end
end
