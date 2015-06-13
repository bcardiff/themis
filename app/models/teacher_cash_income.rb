# Teacher cash on behalf school
# payment_amount > 0 incomes that should be transfered to the school
# payment_amount < 0 expenses of the teacher / fixes of balances
class TeacherCashIncome < ActiveRecord::Base
  belongs_to :teacher

  PAYMENT_ON_TEACHER = 'teacher'

  scope :owed, -> { where(payment_status: PAYMENT_ON_TEACHER) }

  before_create do
    self.payment_status = PAYMENT_ON_TEACHER
  end

end
