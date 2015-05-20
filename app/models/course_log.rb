class CourseLog < ActiveRecord::Base
  belongs_to :course
  validates_presence_of :course, :date

  has_many :teacher_course_logs
  # has_many :teachers, throught: ...

  scope :missing, -> { where(missing: true) }

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
    for_course_on_date(data['course'], data['today']) do |course_log|
      course_log.add_teacher(data['teachers'])
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
    teacher = Teacher.find_by!(name: teacher_name)
    teacher = teacher_course_logs.where(teacher: teacher).first || teacher_course_logs.build(teacher: teacher)

    # TODO yield

    teacher.save!

    teacher
  end
end
