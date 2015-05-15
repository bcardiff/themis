class CourseLog < ActiveRecord::Base
  belongs_to :course
  validates_presence_of :course, :date

  def self.for_course_on_date(course_code, date)
    course = Course.find_by!(code: course_code)
    date = Date.parse(date)

    CourseLog.find_or_initialize_by(course: course, date: date)
  end
end
