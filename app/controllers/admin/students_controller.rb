class Admin::StudentsController < Admin::BaseController
  expose(:student, attributes: :student_params)
  before_action :set_stats_range, only: [:stats, :stats_details]

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
    @global_stats = empty_stat_entry
    @stats = {}
    @stats_by_track = {}
    @stats_by_wday = {}

    StudentCourseLog.between(@date_range).eager_load(course_log: { course: :track }).each do |student_course_log|
      count_stat_entry @global_stats, student_course_log

      weekday_entry = @stats[student_course_log.course_log.course.weekday] ||= {}
      stat_entry = weekday_entry[student_course_log.course_log.course.track.code] ||= empty_stat_entry
      count_stat_entry stat_entry, student_course_log

      bytrack_entry = @stats_by_track[student_course_log.course_log.course.track.code] ||= empty_stat_entry
      count_stat_entry bytrack_entry, student_course_log

      bywday_entry = @stats_by_wday[student_course_log.course_log.course.weekday] ||= empty_stat_entry
      count_stat_entry bywday_entry, student_course_log
    end

    @weekdays = (1..6).to_a
    @tracks = Track.all
  end

  def stats_details
    @track = Track.find(params[:track_id]) if params[:track_id]
    @wday = params[:wday].to_i if params[:wday].present?
  end

  def missing_payment
  end

  def cancel_debt
    student = Student.find(params[:id])
    student.student_course_logs.missing_payment.update_all(requires_student_pack: false)
    redirect_to [:admin, student]
  end

  def destroy
    student = Student.find(params[:id])
    student.destroy
    redirect_to admin_students_path
  end

  def remove_activity_log
    activity_log = ActivityLogs::Student::Payment.find(params[:id])
    student = activity_log.target
    activity_log.related.delete
    activity_log.delete

    redirect_to [:admin, student]
  end

  def remove_pack
    pack = StudentPack.find(params[:id])
    student = pack.student

    ids = pack.student_course_logs.pluck(:id)
    pack.student_course_logs.update_all(student_pack_id: nil)
    pack.destroy
    StudentCourseLog.where(id: ids).each do |student_course_log|
      student_course_log.assign_to_pack_if_no_payment
    end

    redirect_to [:admin, student]
  end

  private

  def student_params
    params.require(:student).permit(:first_name, :last_name, :email, :card_code)
  end

  def count_stat_entry(stat_entry, student_course_log)
    stat_entry[:total_count] = stat_entry[:total_count] + 1
    unless stat_entry[:student_ids][student_course_log.student_id]
      stat_entry[:count] = stat_entry[:count] + 1
      stat_entry[:student_ids][student_course_log.student_id] = true
    end
  end

  def empty_stat_entry
    { count: 0, total_count: 0, student_ids: {} }
  end

  def set_stats_range
    if params[:from].blank? || params[:to].blank?
      default_range = view_context.recent_time_span
      redirect_to url_for(params.merge({from: default_range.begin, to: default_range.end}))
      return
    end
    @date_range = Date.parse(params[:from])..Date.parse(params[:to])
    @stats_url_options = { from: params[:from], to: params[:to] }
  end

end
