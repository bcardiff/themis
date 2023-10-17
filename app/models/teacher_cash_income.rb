# Teacher cash on behalf school
# payment_amount > 0 incomes that should be transfered to the school
# payment_amount < 0 expenses of the teacher / fixes of balances
class TeacherCashIncome < ActiveRecord::Base
  belongs_to :teacher
  validates_presence_of :date
  validates_presence_of :teacher

  PAYMENT_ON_TEACHER = 'teacher'.freeze
  PAYMENT_ON_SCHOOL = 'school'.freeze

  scope :owed, -> { where(payment_status: PAYMENT_ON_TEACHER) }
  scope :handed, -> { where(payment_status: PAYMENT_ON_SCHOOL) }
  scope :handed_at_month, lambda { |time|
                            handed.where('transferred_at >= ?', time.at_beginning_of_month).where('transferred_at < ?', time.at_beginning_of_month.next_month)
                          }

  before_create do
    self.payment_status = PAYMENT_ON_TEACHER
  end

  before_destroy do
    payment_status != PAYMENT_ON_SCHOOL
  end
end
