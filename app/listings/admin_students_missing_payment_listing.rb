class AdminStudentsMissingPaymentListing < Listings::Base
  model do
    @date = Date.parse(params['date'])
    Student.missing_payment(@date)
  end

  column :card_code
  column 'Student' do |student|
    link_to(student.display_name, admin_student_path(student))
  end
  column :email do |student|
    mail_to student.email
  end
  column 'Este mes' do |student|
    student.pending_payments_count(@date.month_range)
  end
  column 'Total', &:pending_payments_count

  export :xls, :csv
end
