class Place < ActiveRecord::Base
  CABALLITO = 'Donarte'

  validates_presence_of :name

  has_many :courses

  def expenses
    TeacherCashIncome.where(place_id: self.id)
  end

  def incomes
    course_logs = CourseLog.arel_table
    TeacherCashIncome.where("course_log_id IN (#{course_logs.project(:id).where(course_logs[:course_id].in(self.courses.pluck(:id))).to_sql})")
  end

  def after_payment(student_payment_income)
    if commission > 0
      student_course_log = student_payment_income.student_course_log
      commission_expense = TeacherCashIncomes::PlaceCommissionExpense.find_or_initialize_by_student_course_log(student_course_log)
      commission_expense.payment_amount = - student_payment_income.payment_amount * commission / student_course_log.payment_plan.weekly_classes.to_f
      commission_expense.save!
    end
  end

  def commission
    name == CABALLITO ? 0.3 : 0
  end

  def expenses_total
    - expenses.sum(:payment_amount)
  end
end
