class Student < ActiveRecord::Base
  UNKOWN = "N/A"

  validates_presence_of :first_name
  validates_uniqueness_of :card_code, allow_nil: true
   #TODO uniq card, email

  def display_name
    "#{first_name} #{last_name}"
  end

  def account
    DoubleEntry.account(:student_account, :scope => self)
  end

  def record_payment(plan, amount, teacher)
    DoubleEntry.transfer(Money.new(amount * 100),
      from: self.account, to: teacher.student_payments_account, code: :course_payment)
  end
end
