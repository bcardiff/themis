class AdminTeacherCoursesListing < Listings::Base
  model do
    TeacherCourseLog.joins(:course_log).order('course_logs.date desc')
  end

  scope 'Todos', :all, default: true
  scope 'Por pagar a profesor', :due
  scope "Pagados", :paid

  column 'Fecha Curso' do |teacher_course_log|
    teacher_course_log.course_log.date
  end

  column 'Curso' do |teacher_course_log|
    teacher_course_log.course_log.calendar_name
  end

  column 'Profesor' do |teacher_course_log|
    teacher_course_log.teacher.name
  end

  column :paid_at do |teacher_course_log|
    teacher_course_log.paid_at.try :to_date
  end

  column :payment_amount do |teacher_course_log|
    number_to_currency teacher_course_log.paid_amount
  end

end
