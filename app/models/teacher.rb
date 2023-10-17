class Teacher < ActiveRecord::Base
  validates_numericality_of :fee

  scope :active, -> { where('deleted_at IS NULL') }
  scope :for_classes, -> { active.where('priority > 0').order(:priority, :name) }

  has_many :teacher_course_logs
  has_many :course_logs, through: :teacher_course_logs

  has_many :student_course_logs

  has_many :teacher_cash_incomes

  has_many :ona_submission_subscriptions, as: :follower
  has_many :ona_submissions, through: :ona_submission_subscriptions

  def owed_cash(date)
    teacher_cash_incomes.owed.where('date <= ?', date)
  end

  def owed_cash_total
    teacher_cash_incomes.owed.sum(:payment_amount)
  end

  def transfer_cash_income_money(real_amount, date)
    owed_cash_records = owed_cash(date)
    amount = owed_cash_records.sum(:payment_amount)
    delta = real_amount - amount

    transferred_at = Time.now

    if delta != 0
      fix_amount = TeacherCashIncomes::FixAmountIncome.create!(teacher: self, date: transferred_at,
                                                               payment_amount: delta)
      fix_amount.payment_status = TeacherCashIncome::PAYMENT_ON_SCHOOL
      fix_amount.transferred_at = transferred_at
      fix_amount.save!
    end

    owed_cash_records.update_all(payment_status: TeacherCashIncome::PAYMENT_ON_SCHOOL, transferred_at: transferred_at)
  end

  def handed_course_payments_per_month(time)
    teacher_cash_incomes.handed_at_month(time).sum(:payment_amount)
  end

  def course_teaching_expense_per_month(time)
    teacher_course_logs.paid_at_month(time).sum(:paid_amount)
  end

  def due_salary_total
    due_salary(Time.now)
  end

  def due_salary(date)
    teacher_course_logs.due_up_to(date).count * fee
  end

  def pay_pending_classes(date)
    teacher_course_logs.due_up_to(date).update_all(paid: true, paid_at: Time.now, paid_amount: fee)
  end

  def cashier?
    cashier
  end
end
