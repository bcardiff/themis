class ActivityLogs::Student::Payment < ActivityLog
  def self.record(student, student_course_log)
    create(target: student,
      related: student_course_log,
      date: student_course_log.course_log.date,
      description: "Abonó #{student_course_log.payment_amount} a #{student_course_log.teacher.name}.")
  end

  def self.for(student, student_course_log)
    where(target: student, related: student_course_log, date: student_course_log.course_log.date)
  end
end
