class AdminCourseLogStudentsListing < Listings::Base
  model do
    @course_log = CourseLog.find(params[:id])
    @course_log.students
  end

  column :card_code#, searchable: true
  column :first_name#, searchable: true
  column :email#, searchable: true
  column 'Pago' do |student|
    student_log = @course_log.student_course_logs.where(student: student).first
    if student_log.payment_status
      "#{number_to_currency student_log.payment_amount}"
    end
  end

  export :csv, :xls

end
