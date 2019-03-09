class Admin::CoursesController < Admin::BaseController
  def index
  end

  def listing
  end

  def new
    @course = Course.new(weekday: params[:weekday].to_i, start_time: params[:start_time])
  end

  def create
    @course = Course.new(course_params)
    @course.code = Course.next_code(@course.track, @course.weekday.to_i) if @course.track

    if @course.save
      redirect_to admin_courses_path
    else
      render :new
    end
  end

  private

  def course_params
    params.require(:course).permit(:track_id, :weekday, :start_time, :valid_since)
  end
end
