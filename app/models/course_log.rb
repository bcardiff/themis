class CourseLog < ActiveRecord::Base
  belongs_to :course
  validates_presence_of :course, :date
  validate :validate_course_date

  has_many :teacher_course_logs, dependent: :destroy
  has_many :teachers, through: :teacher_course_logs

  has_many :student_course_logs

  scope :missing, -> { where(missing: true) }

  delegate :calendar_name, to: :course

  def students_count
    self.student_course_log.count
  end

  def validate_course_date
    if date && date.wday != course.weekday
      errors.add(:date, "invalid date for course #{date} is #{Date::DAYNAMES[date.wday]} but not #{Date::DAYNAMES[course.weekday]}")
    end
  end

  def self.fill_missings
    today = Date.today

    Course.joins('LEFT JOIN "course_logs" ON "course_logs"."course_id" = "courses"."id"')
      .select("courses.*, max(course_logs.date) as last")
      .group("courses.id").each do |course|
      next_date = (course.last || (course.valid_since - 1.day)).next_wday(course.weekday)

      while next_date < today
        for_course_on_date(course.code, next_date) do |course_log|
          course_log.missing = true
        end

        next_date = next_date + 1.week
      end
    end
  end

  def self.process(data)
    for_course_on_date(data['course'], data['date']) do |course_log|
      teacher = course_log.add_teacher(data['teachers'])

      (data['student_repeat'] || []).each do |student_payload|
        StudentCourseLog.process(course_log, teacher, student_payload)
      end
    end
  end

  def self.for_course_on_date(course_code, date)
    course = Course.find_by!(code: course_code)
    date = Date.parse(date) unless date.is_a? Date

    course_log = CourseLog.find_or_initialize_by(course: course, date: date)
    course_log.missing = false

    yield course_log if block_given?

    course_log.save!

    course_log
  end

  def add_teacher(teacher_name)
    return nil if teacher_name.blank?

    teacher = Teacher.find_by!(name: teacher_name)
    teacher_log = teacher_course_logs.first_or_build(teacher: teacher)

    teacher_log.save!

    teacher
  end

  def status
    self.missing ? 'Sin información enviada' : 'Ok'
  end
end