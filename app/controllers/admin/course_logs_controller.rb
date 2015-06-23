class Admin::CourseLogsController < Admin::BaseController
  expose(:course_log)

  def show
    @new_student_course_log = course_log.student_course_logs.build
  end

  def autocomplete_student
    data = Student.autocomplete(params[:q]).take(10).map do |s|
      [s.id, s.autocomplete_display_name]
    end

    render json: data
  end
end
