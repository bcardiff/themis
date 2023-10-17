class Admin::CoursesController < Admin::BaseController
  before_filter :set_valid_since_options, only: %i[new create]
  before_filter :set_valid_until_options, only: %i[show update]

  def index; end

  def listing; end

  def new
    place = Place.find(params[:place_id])
    @course = Course.new(weekday: params[:weekday].to_i, start_time: params[:start_time], place: place)
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

  def show
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    @course.valid_until = params[:course][:valid_until]

    if @course.save
      redirect_to admin_courses_path
    else
      render :show
    end
  end

  def destroy
    @course = Course.find(params[:id])
    @course.destroy if @course.can_destroy?

    redirect_to admin_courses_path
  end

  private

  def course_params
    params.require(:course).permit(:track_id, :place_id, :weekday, :start_time, :valid_since)
  end

  def set_valid_since_options
    @valid_since_options = [School.today.at_beginning_of_month, (School.today + 1.month).at_beginning_of_month]
  end

  def set_valid_until_options
    @valid_until_options = [nil, School.today.at_end_of_month, School.today]
  end
end
