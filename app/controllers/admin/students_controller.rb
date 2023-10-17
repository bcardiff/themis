class Admin::StudentsController < Admin::BaseController
  expose(:student, attributes: :student_params)
  before_action :set_stats_range, only: %i[stats stats_details]

  SHARED_ACTIONS = %i[advance_pack postpone_pack].freeze
  skip_before_action :only_admin, only: SHARED_ACTIONS
  before_action :only_admin_or_cashier, only: SHARED_ACTIONS

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

  def flow_stats
    start = 1.year.ago.at_beginning_of_month

    filter_period = ->(relation) { relation.where('created_at >= ?', start) }
    # filter_period = -> (relation) { relation.all }

    @periods = []
    @stats = {}

    # new_students
    filter_period.call(Student).group('EXTRACT(YEAR_MONTH FROM created_at)')
      .select('count(*) as count, EXTRACT(YEAR_MONTH FROM created_at) as period')
      .each do |r|
        @periods << r[:period]
        @stats[r[:period]] ||= { incoming: nil, active: nil, drops: nil }
        @stats[r[:period]][:incoming] = r[:count]
      end

    # Activos
    filter_period.call(StudentCourseLog).group('EXTRACT(YEAR_MONTH FROM created_at)')
      .select('count(distinct student_id) as count, EXTRACT(YEAR_MONTH FROM created_at) as period')
      .each do |r|
        @periods << r[:period]
        @stats[r[:period]] ||= { incoming: nil, active: nil, drops: nil }
        @stats[r[:period]][:active] = r[:count]
      end

    # drops
    filter_period.call(StudentCourseLog).group('EXTRACT(YEAR_MONTH FROM created_at)')
      .select('count(student_id) as count, EXTRACT(YEAR_MONTH FROM created_at) as period')
      .where('created_at = (SELECT MAX(t.created_at) FROM student_course_logs as t WHERE t.student_id = student_course_logs.student_id)')
      .each do |r|
        @periods << r[:period]
        @stats[r[:period]] ||= { incoming: nil, active: nil, drops: nil }
        @stats[r[:period]][:drops] = r[:count]
      end

    @periods.uniq!
    @periods.sort!
  end

  def flow_stats_drops_details; end

  def drop_off; end

  def drop_off_stats
    @w1 = School.today.first_week
    @w2 = School.today.second_week
    @w3 = School.today.third_week

    @s1 = Student.where(id: StudentCourseLog.joins(:course_log).between(@w1).select(:student_id))
    @s2 = Student.where(id: StudentCourseLog.joins(:course_log).between(@w2).select(:student_id))
    @s3 = Student.where(id: StudentCourseLog.joins(:course_log).between(@w3).select(:student_id))

    @d2 = @s1 - @s2
    @d3 = (@s2 - @s1) - @s3
  end

  def course_stats
    query = StudentCourseLog.all.group('course_id, EXTRACT(YEAR FROM course_logs.date), EXTRACT(WEEK FROM course_logs.date)')
      .select('course_id, EXTRACT(YEAR FROM course_logs.date) as year, EXTRACT(WEEK FROM course_logs.date) as week, count(student_id) as count')
      .joins(course_log: :course)
      .where('courses.valid_until IS NULL')
      .where('course_logs.date > ?', 3.months.ago.beginning_of_week.to_date)
      .order('EXTRACT(YEAR FROM course_logs.date), EXTRACT(WEEK FROM course_logs.date)')

    @courses_by_track = Course.ongoing_or_future.includes(:track).order('tracks.code, weekday').group_by(&:track)

    @data = []
    current = nil
    query.each do |row|
      period = "#{row[:year]} - #{row[:week]}"
      @data << current = { period: period } if current.nil? || current[:period] != period
      current[row[:course_id]] = row[:count]
    end
  end

  def missing_payment; end

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
    StudentCourseLog.where(id: ids).each(&:assign_to_pack_if_no_payment)

    redirect_to [:admin, student]
  end

  def advance_pack
    with_pack do |pack|
      AdvanceStudentPackAction.new(current_user, pack).call
    end
  end

  def postpone_pack
    with_pack do |pack|
      PostponeStudentPackAction.new(current_user, pack).call
    end
  end

  private

  def with_pack
    pack = StudentPack.find(params[:id])
    # student = pack.student
    yield pack
    redirect_to :back
  end

  def student_params
    params.require(:student).permit(:first_name, :last_name, :email, :card_code)
  end

  def count_stat_entry(stat_entry, student_course_log)
    stat_entry[:total_count] = stat_entry[:total_count] + 1
    return if stat_entry[:student_ids][student_course_log.student_id]

    stat_entry[:count] = stat_entry[:count] + 1
    stat_entry[:student_ids][student_course_log.student_id] = true
  end

  def empty_stat_entry
    { count: 0, total_count: 0, student_ids: {} }
  end

  def set_stats_range
    if params[:from].blank? || params[:to].blank?
      default_range = view_context.recent_time_span
      redirect_to url_for(params.merge({ from: default_range.begin, to: default_range.end }))
      return
    end
    @date_range = Date.parse(params[:from])..Date.parse(params[:to])
    @stats_url_options = { from: params[:from], to: params[:to] }
  end
end
