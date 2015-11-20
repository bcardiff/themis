class ActivityLogs::Student::CourseAttended < ActivityLog
  def self.record(student, course_log)
    find_or_create_by target: student, related: course_log, date: course_log.date do |log|
      log.description = "Asistió a #{course_log.calendar_name}."
    end
  end

  def self.for(student, course_log)
    where(target: student, related: course_log, date: course_log.date)
  end

  def student_course_log
    StudentCourseLog.find_by(student: target, course_log: related)
  end
end
