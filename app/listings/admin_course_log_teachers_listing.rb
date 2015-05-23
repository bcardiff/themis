class AdminCourseLogTeachersListing < Listings::Base
  model do
    @course_log = CourseLog.find(params[:id])
    @course_log.teachers
  end

  column :name
  column 'Pagos de alumnos' do |teacher|
    teacher_log = @course_log.teacher_course_logs.where(teacher: teacher).first
    number_to_currency teacher_log.student_course_logs.sum(:payment_amount)
  end

end
