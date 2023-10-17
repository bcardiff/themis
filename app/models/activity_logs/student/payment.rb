class ActivityLogs::Student::Payment < ActivityLog
  def self.record_cashier_pack_payment(student, student_course_log_or_income, payment_plan)
    find_or_create_by(target: student, related: student_course_log_or_income,
                      date: student_course_log_or_income.date).tap do |log|
      log.description = "Abonó #{student_course_log_or_income.payment_amount} a #{student_course_log_or_income.teacher.name} por #{payment_plan.code}."
      log.save!
    end
  end

  def self.record(student, student_course_log_or_income)
    find_or_create_by(target: student, related: student_course_log_or_income,
                      date: student_course_log_or_income.date).tap do |log|
      log.description = "Abonó #{student_course_log_or_income.payment_amount} a #{student_course_log_or_income.teacher.name}."
      log.save!
    end
  end

  def self.for(student, student_course_log)
    where(target: student, related: student_course_log, date: student_course_log.course_log.date)
  end
end
