class Course < ActiveRecord::Base
  has_many :course_logs

  validates_presence_of :weekday, :valid_since
end
