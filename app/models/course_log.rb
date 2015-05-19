class CourseLog < ActiveRecord::Base
  belongs_to :course
  validates_presence_of :course, :date

  has_many :teacher_course_logs
  # has_many :teachers, throught: ...

  def self.process(data)
    for_course_on_date(data['course'], data['today']) do |course_log|
      course_log.add_teacher(data['teachers'])
    end
  end

  def self.for_course_on_date(course_code, date)
    course = Course.find_by!(code: course_code)
    date = Date.parse(date)

    course_log = CourseLog.find_or_initialize_by(course: course, date: date)

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
