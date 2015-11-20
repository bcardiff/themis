class AdminStudentsMissingPaymentListing < Listings::Base
  model {
    @date = Date.parse(params['date'])
    Student.missing_payment(@date)
  }

  column :card_code
  column 'Student' do |student|
    link_to(student.display_name, admin_student_path(student))
  end
  column :email do |student|
    mail_to student.email
  end
  column 'Este mes' do |student|
    student.student_course_logs.missing_payment.joins(:course_log).between(@date.month_range).count
  end
  column 'Total' do |student|
    student.student_course_logs.missing_payment.count
  end

  export :xls, :csv

end
