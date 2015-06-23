class Admin::StudentsController < Admin::BaseController
  expose(:student, attributes: :student_params)

  def update
    if student.save
      redirect_to admin_student_path(student)
    else
      render :edit
    end
  end

  def create
    if student.save
      redirect_to [:admin, student]
    else
      render :new
    end
  end

  def stats
    @global_stats = { count: 0, student_ids: {} }
    @stats = {}
    @stats_by_track = {}
    @stats_by_wday = {}

    StudentCourseLog.eager_load(course_log: { course: :track }).each do |student_course_log|
      count_stat_entry @global_stats, student_course_log

      weekday_entry = @stats[student_course_log.course_log.course.weekday] ||= {}
      stat_entry = weekday_entry[student_course_log.course_log.course.track.code] ||= { count: 0, student_ids: {} }
      count_stat_entry stat_entry, student_course_log

      bytrack_entry = @stats_by_track[student_course_log.course_log.course.track.code] ||= { count: 0, student_ids: {} }
      count_stat_entry bytrack_entry, student_course_log

      bywday_entry = @stats_by_wday[student_course_log.course_log.course.weekday] ||= { count: 0, student_ids: {} }
      count_stat_entry bywday_entry, student_course_log
    end

    @weekdays = (1..6).to_a
    @tracks = Track.all
  end

  def stats_details
    @track = Track.find(params[:track_id]) if params[:track_id]
    @wday = params[:wday].to_i if params[:wday].present?
  end

  private

  def student_params
    params.require(:student).permit(:first_name, :last_name, :email, :card_code)
  end

  def count_stat_entry(stat_entry, student_course_log)
    unless stat_entry[:student_ids][student_course_log.student_id]
      stat_entry[:count] = stat_entry[:count] + 1
      stat_entry[:student_ids][student_course_log.student_id] = true
    end
  end
end
