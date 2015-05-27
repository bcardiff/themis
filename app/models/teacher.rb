class Teacher < ActiveRecord::Base
  has_many :teacher_course_logs
  has_many :student_course_logs do
    def transfer_student_payments_money
      owed.update_all(payment_status: StudentCourseLog::PAYMENT_ON_CLASSES_INCOME)
    end
  end

  def owed_student_payments
    student_course_logs.owed.sum(:payment_amount)
  end

  def transfer_student_payments_money
    account_from = self.student_payments_account
    account_to = School.course_income_account

    # DoubleEntry.lock_accounts(account_from, account_to) do
      amount = self.owed_student_payments
      DoubleEntry.transfer(Money.new(amount * 100),
        from: account_from, to: account_to, code: :deliver_student_payment)

      student_course_logs.transfer_student_payments_money
    # end
  end

  def student_payments_account
    DoubleEntry.account(:student_payments, :scope => self)
  end
end
