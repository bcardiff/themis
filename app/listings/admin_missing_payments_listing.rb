class AdminMissingPaymentsListing < Listings::Base
  # include ApplicationHelper

  model do
    @date = Date.parse(params['date'])
    StudentCourseLog.missing_payment.includes({ course_log: :course },
                                              :student).between(@date.month_range).order('course_logs.date desc')
  end

  column :date do |student_course_log|
    student_course_log.course_log.date
  end

  column 'Curso' do |student_course_log|
    student_course_log.course_log.course.description(:track, :weekday, :time)
  end

  column :student do |student_course_log|
    link_to(student_course_log.student.display_name, admin_student_path(student_course_log.student))
  end

  export :xls, :csv
end
