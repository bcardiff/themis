class StudentPack < ActiveRecord::Base
  belongs_to :student
  belongs_to :payment_plan
  has_many :student_course_logs

  scope :valid_for, -> (date) { where("start_date <= ? AND due_date >= ?", date, date) }

  def available_courses
    self.max_courses - self.student_course_logs.count
  end

  def rollback_candidate_payment(user)
    incomes = TeacherCashIncomes::StudentPaymentIncome.owed.where(student: self.student, payment_amount: self.payment_plan.price)
    if !user.admin?
      incomes = incomes.where(teacher: user.teacher)
    end
    incomes.first
  end

  def can_rollback_payment_and_pack?(user)
    return !rollback_candidate_payment(user).nil?
  end

  def rollback_payment_and_pack(user)
    income = rollback_candidate_payment(user)
    raise "unable to rollback this pack" if income.nil?

    ActiveRecord::Base.transaction do
      student.student_course_logs.where(student_pack: self).update_all(student_pack_id: nil)
      income.delete
      self.delete
      ActivityLogs::Student::Payment.where(target: self.student, related: income).first.delete
    end
  end

  def self.register_for(student, date, price)
    plan = PaymentPlan.find_by(price: price)
    start_date = date.to_date.at_beginning_of_month
    if plan && !plan.single_class?
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
    elsif plan && plan.single_class?
      due_date = start_date.at_end_of_month
      max_courses = 1
    else
      single_class_price = PaymentPlan.find_by(code: PaymentPlan::SINGLE_CLASS).price
      plan = PaymentPlan.find_by(code: PaymentPlan::OTHER)
      due_date = start_date.at_end_of_month
      max_courses = price / single_class_price
    end

    pack = self.create!(student: student, payment_plan: plan, start_date: start_date, due_date: due_date, max_courses: max_courses)
    begin
      StudentNotifications.pack_granted(pack).deliver_now if plan && student.email && plan.notify_purchase?
    rescue => ex
      logger.warn ex
    end
    pack
  end

  def total_payed
    self.student_course_logs.sum(:payment_amount)
  end

  def self.recalculate(student_payment_income)
    # TODO transaction!

    student = student_payment_income.student
    date = student_payment_income.date.at_beginning_of_month
    date_range = date..date.at_end_of_month

    # grab the existing student_pack if we are deleting/updating and existing income
    pack_to_extend = student_payment_income.student_course_log.try :student_pack
    if pack_to_extend.nil?
      # if the income is fresh, check if it should extend the last partial payment in the month
      pack_to_extend = student.student_packs.where(start_date: date_range).last
      pack_to_extend = nil if pack_to_extend && !pack_to_extend.payment_plan.other?
    end

    total = 0
    total = pack_to_extend.total_payed if pack_to_extend
    unless student_payment_income.destroyed?
      total = total + student_payment_income.payment_amount if pack_to_extend.nil? || !pack_to_extend.student_course_logs.include?(student_payment_income.student_course_log)
    end

    if pack_to_extend
      student.student_course_logs.where(student_pack_id: pack_to_extend.id).update_all(student_pack_id: nil)
      pack_to_extend.destroy
    end

    if PaymentPlan.find_by(price: total).try(:single_class?)
      return if student_payment_income.student_course_log
    end

    student_pack = register_for(student, date, total)

    ids = student.student_course_logs.includes(:course_log)
      .missing_payment.between(date_range)
      .pluck(:id)
      .take(student_pack.max_courses)

    StudentCourseLog.where(id: ids).update_all(student_pack_id: student_pack.try(&:id))
  end

  def self.check_assign_student_course_log(student_course_log)
    valid_packs = student_course_log.student.student_packs.valid_for(student_course_log.course_log.date).order(:due_date)
    valid_packs.each do |existing_pack|
      if existing_pack && existing_pack.student_course_logs.count < existing_pack.max_courses
        StudentCourseLog.where(id: student_course_log.id).update_all(student_pack_id: existing_pack.try(&:id))
        return
      end
    end
  end
end
