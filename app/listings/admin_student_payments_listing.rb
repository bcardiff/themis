class AdminStudentPaymentsListing < Listings::Base
  model do
    StudentCourseLog.with_payment.joins(:course_log).order('course_logs.date desc')
  end

  scope 'Todos', :all, default: true
  scope 'En Profesor', :owed
  scope "Entregados a #{School.description}", :handed

  column 'Fecha pago' do |student_course_log|
    student_course_log.course_log.date
  end

  column 'Curso' do |student_course_log|
    student_course_log.course_log.calendar_name
  end

  column 'Profesor' do |student_course_log|
    student_course_log.teacher.name
  end

  column :transferred_at do |student_course_log|
    student_course_log.transferred_at.try :to_date
  end

  column 'Alumno' do |student_course_log|
    student_course_log.student.display_name
  end

  column :payment_amount do |student_course_log|
    number_to_currency student_course_log.payment_amount
  end

  column :payment_status do |student_course_log|
    case student_course_log.payment_status
    when StudentCourseLog::PAYMENT_ON_TEACHER
      "Profesor"
    when StudentCourseLog::PAYMENT_ON_CLASSES_INCOME
      School.description
    else
      student_course_log.payment_status
    end
  end

  export :xls, :csv

end
