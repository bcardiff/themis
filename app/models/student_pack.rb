class StudentPack < ActiveRecord::Base
  belongs_to :student
  belongs_to :payment_plan
  validate :no_overlapping_dates

  def no_overlapping_dates
    overlapping = StudentPack.where(student: student, start_date: start_date..due_date).count
    overlapping += StudentPack.where(student: student, due_date: start_date..due_date).count if overlapping == 0
    overlapping += StudentPack.where(student: student).where("start_date <= ? AND due_date >= ?", start_date, due_date).count if overlapping == 0
    if overlapping > 0
      errors.add(:start_date, "can't overlap existing plans")
    end
  end

  def self.register_for(student, date, price)
    plan = PaymentPlan.find_by(price: price)
    start_date = date.to_date.at_beginning_of_month
    return nil unless plan

    if plan.code == "3_MESES"
      due_date = (start_date + 2.months).at_end_of_month
    else
      due_date = start_date.at_end_of_month
    end

    case plan.code
    when "1_X_SEMANA_3"
      weeks = 3
    when "1_X_SEMANA_4"
      weeks = 4
    when "1_X_SEMANA_5"
      weeks = 5
    else
      current_date = start_date
      weeks = 0
      while current_date <= due_date
        current_date = current_date + 1.week
        weeks += 1
      end
    end

    max_courses = weeks * plan.weekly_classes

    self.create(student: student, payment_plan: plan, start_date: start_date, due_date: due_date, max_courses: max_courses)
  end

  def self.recalculate(student, date)
    date_range = date..date.at_end_of_month
    total = TeacherCashIncomes::StudentPaymentIncome.includes(:student_course_log).where(student_course_logs: {student_id: student.id}, date: date_range).sum(:payment_amount)
    student_pack = register_for(student, date, total)

    ids = StudentCourseLog.includes(:course_log).where(requires_student_pack: true, course_logs: { date: date_range}).pluck(:id)
    StudentCourseLog.where(id: ids).update_all(student_pack_id: student_pack.try(&:id))
  end
end
