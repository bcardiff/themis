class StudentPack < ActiveRecord::Base
  belongs_to :student
  belongs_to :payment_plan
  validate :no_overlapping_dates
  has_many :student_course_logs

  scope :valid_for, -> (date) { where("start_date <= ? AND due_date >= ?", date, date) }

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
    if plan
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
    else
      single_class_price = PaymentPlan.find_by(code: PaymentPlan::SINGLE_CLASS).price
      plan = PaymentPlan.find_by(code: PaymentPlan::OTHER)
      due_date = start_date.at_end_of_month
      max_courses = price / single_class_price
    end

    self.create(student: student, payment_plan: plan, start_date: start_date, due_date: due_date, max_courses: max_courses)
  end

  def self.recalculate(student, date)
    date_range = date..date.at_end_of_month
    total = TeacherCashIncomes::StudentPaymentIncome.pack_payment()
      .includes(:student_course_log)
      .where(student_course_logs: {student_id: student.id}, date: date_range)
      .sum(:payment_amount)

    existing_pack = student.student_packs.valid_for(date).first
    if existing_pack
      student.student_course_logs.where(student_pack_id: existing_pack.id).update_all(student_pack_id: nil)
      existing_pack.destroy
    end

    student_pack = register_for(student, date, total)

    ids = student.student_course_logs.includes(:course_log)
      .where(requires_student_pack: true, course_logs: { date: date_range})
      .pluck(:id)
      .take(student_pack.max_courses)

    StudentCourseLog.where(id: ids).update_all(student_pack_id: student_pack.try(&:id))
  end

  def self.check_assign_student_course_log(student_course_log)
    existing_pack = student_course_log.student.student_packs.valid_for(student_course_log.course_log.date).first
    if existing_pack && existing_pack.student_course_logs.count < existing_pack.max_courses
      StudentCourseLog.where(id: student_course_log.id).update_all(student_pack_id: existing_pack.try(&:id))
    end
  end
end
