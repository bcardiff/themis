class TeacherCourseLogTeachersListing < Listings::Base
  model do
    @course_log = CourseLog.find(params[:course_log_id] || params[:id])
    Teacher.where(id: @course_log.student_course_logs.select(:teacher_id).distinct)
  end

  column :name
  column 'Pagos de alumnos' do |teacher|
    number_to_currency @course_log.incomes.where(teacher: teacher).sum(:payment_amount)
  end
end
