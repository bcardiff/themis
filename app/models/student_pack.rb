class StudentPack < ActiveRecord::Base
  belongs_to :student
  belongs_to :payment_plan
  has_many :student_course_logs

  scope :valid_for_course_log, lambda { |course_log|
    joins(:payment_plan)
      .valid_for_date(course_log.date)
      .where('payment_plans.course_match like ?', "%#{course_log.course_kind}%")
  }
  scope :valid_for_date, ->(date) { where('start_date <= ? AND due_date >= ?', date, date) }

  def available_courses
    max_courses - student_course_logs.count
  end

  def rollback_candidate_payment(user)
    incomes = TeacherCashIncomes::StudentPaymentIncome.owed.where(student: student,
                                                                  payment_amount: payment_plan.price)
    incomes = incomes.where(teacher: user.teacher) unless user.admin?
    incomes.first
  end

  def can_rollback_payment_and_pack?(user)
    !rollback_candidate_payment(user).nil?
  end

  def rollback_payment_and_pack(user)
    income = rollback_candidate_payment(user)
    raise 'unable to rollback this pack' if income.nil?

    ActiveRecord::Base.transaction do
      student.student_course_logs.where(student_pack: self).update_all(student_pack_id: nil)
      income.delete
      delete
      ActivityLogs::Student::Payment.where(target: student, related: income).first.delete
    end
  end

  def self.register_for(student, date, price, payment_plan_on_cashier = nil)
    plan = payment_plan_on_cashier || PaymentPlan.find_by(price: price)
    start_date = date.to_date.at_beginning_of_month
    if plan && !plan.single_class?
      due_date = case plan.code
                 when '3_MESES', '3_MESES_CASH'
                   (start_date + 2.months).at_end_of_month
                 when '2_MESES_LIBRE'
                   (start_date + 1.months).at_end_of_month
                 else
                   start_date.at_end_of_month
                 end

      case plan.code
      when '1_X_SEMANA_3', '1_X_SEMANA_3_CASH'
        weeks = 3
      when '1_X_SEMANA_4', '1_X_SEMANA_4_CASH', '1_X_SEMANA_4_SALE_30', '1_X_SEMANA_4_SALE_50'
        weeks = 4
      when '1_X_SEMANA_5', '1_X_SEMANA_5_CASH'
        weeks = 5
      else
        current_date = start_date
        weeks = 0
        while current_date <= due_date
          current_date += 1.week
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

    pack = create!(student: student, payment_plan: plan, start_date: start_date, due_date: due_date,
                   max_courses: max_courses)
    begin
      StudentNotifications.pack_granted(pack).deliver_now if plan && student.email && plan.notify_purchase?
    rescue StandardError => e
      logger.warn e
    end
    pack
  end

  def total_payed
    student_course_logs.sum(:payment_amount)
  end

  def self.recalculate(student_payment_income)
    # TODO: transaction!

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
    if !student_payment_income.destroyed? && (pack_to_extend.nil? || !pack_to_extend.student_course_logs.include?(student_payment_income.student_course_log))
      total += student_payment_income.payment_amount
    end

    if pack_to_extend
      student.student_course_logs.where(student_pack_id: pack_to_extend.id).update_all(student_pack_id: nil)
      pack_to_extend.destroy
    end

    return if PaymentPlan.find_by(price: total).try(:single_class?) && student_payment_income.student_course_log

    student_pack = register_for(student, date, total, student_payment_income.payment_plan_on_cashier)

    student_course_logs_to_assign = student
      .student_course_logs.joins(course_log: { course: :track })
      .missing_payment.between(date_range)

    if student_pack.payment_plan
      student_course_logs_to_assign = student_course_logs_to_assign
        .where("? like CONCAT('%',tracks.course_kind,'%')", student_pack.payment_plan.course_match)
    end

    ids = student_course_logs_to_assign
      .pluck(:id)
      .take(student_pack.max_courses)

    StudentCourseLog.where(id: ids).update_all(student_pack_id: student_pack.try(&:id))
  end

  def self.check_assign_student_course_log(student_course_log)
    return if student_course_log.as_helper

    valid_packs = student_course_log.student.student_packs.valid_for_course_log(student_course_log.course_log).order(:due_date)
    valid_packs.each do |existing_pack|
      if existing_pack && existing_pack.student_course_logs.count < existing_pack.max_courses
        StudentCourseLog.where(id: student_course_log.id).update_all(student_pack_id: existing_pack.try(&:id))
        break
      end
    end
  end

  def receipt
    # check ReceiptController#validate if changed

    headers = StudentPack.receipt_headers
    data = <<-RECEIPT
#{headers[:student]}: #{student.autocomplete_display_name}
#{headers[:pack]}: #{payment_plan.mailer_description}
#{headers[:due_date]}: #{due_date.to_dmy}
#{headers[:receipt]}: #{id}.#{SecureRandom.hex(4)}
    RECEIPT
    data = data.strip
    data_to_sign = data.split.join
    sep = '-' * 50

    "#{sep}\n#{data}\n#{sep}\n#{headers[:sign]}: #{Digest::SHA1.hexdigest(Settings.receipt_secret_key + data_to_sign)}\n#{sep}"
  end

  def self.receipt_headers
    case Settings.branch
    when 'sheffield'
      {
        student: 'Student',
        pack: 'Pack',
        due_date: 'Due date',
        receipt: 'Receipt',
        sign: 'Sign'
      }
    else
      {
        student: 'Alumno',
        pack: 'Pack',
        due_date: 'Vencimiento',
        receipt: 'Comprobante',
        sign: 'Firma'
      }
    end
  end
end
