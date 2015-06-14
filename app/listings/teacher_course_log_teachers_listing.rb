class TeacherCourseLogTeachersListing < Listings::Base
  model do
    @course_log = CourseLog.find(params[:id])
    @course_log.teachers
  end

  column :name
  column 'Pagos de alumnos' do |teacher|
    number_to_currency @course_log.incomes.where(teacher: teacher).sum(:payment_amount)
  end

end
