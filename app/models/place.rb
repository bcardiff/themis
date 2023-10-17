class Place < ActiveRecord::Base
  CABALLITO = 'La Fragua'.freeze

  validates_presence_of :name
  scope :active, -> { where('deleted_at IS NULL') }

  has_many :courses

  has_many :ona_submission_subscriptions, as: :follower
  has_many :ona_submissions, through: :ona_submission_subscriptions

  def self.default
    find_or_create_by!(name: School.description)
  end

  # School expenses due to the place
  def expenses
    TeacherCashIncome.where(place_id: id)
  end

  # School incomes relative to the place
  def incomes
    course_logs = CourseLog.arel_table
    TeacherCashIncome.where("place_id = #{id} OR course_log_id IN (#{course_logs.project(:id).where(course_logs[:course_id].in(courses.pluck(:id))).to_sql})")
  end

  def after_payment(student_payment_income)
    return unless commission > 0

    student_course_log = student_payment_income.student_course_log
    commission_expense = TeacherCashIncomes::PlaceCommissionExpense.find_or_initialize_by_student_course_log(student_course_log)
    commission_expense.payment_amount = - student_payment_income.payment_amount * commission / student_course_log.payment_plan.weekly_classes.to_f
    commission_expense.save!

    after_class(student_course_log.course_log.date, student_payment_income.teacher)
  end

  def after_payment_destroy(student_payment_income)
    student_course_log = student_payment_income.student_course_log
    commission_expense = TeacherCashIncomes::PlaceCommissionExpense.find_or_initialize_by_student_course_log(student_course_log)
    commission_expense.destroy!
  end

  def after_class(date, teacher)
    return unless insurance > 0
    return unless expenses.where(date: date.beginning_of_month..date - 1.day).empty?

    date_expenses = -TeacherCashIncomes::PlaceCommissionExpense.where(place: self, date: date).sum(:payment_amount)
    insurance_expense = TeacherCashIncomes::PlaceInsuranceExpense.find_or_initialize_by_place_date(self, date,
                                                                                                   teacher)
    insurance_expense.payment_amount = - [insurance - date_expenses, 0].max
    insurance_expense.save!
  end

  def after_class_yank(date)
    TeacherCashIncomes::PlaceInsuranceExpense.where(place: self, date: date).each(&:destroy!) if insurance > 0
  end

  def commission?
    name == CABALLITO
  end

  def commission
    name == CABALLITO ? 0.3 : 0
  end

  def insurance
    name == CABALLITO ? 860 : 0
  end

  def expenses_total
    - expenses.sum(:payment_amount)
  end
end
