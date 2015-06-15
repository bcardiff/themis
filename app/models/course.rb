class Course < ActiveRecord::Base
  has_many :course_logs
  belongs_to :place

  validates_presence_of :weekday, :valid_since

  def calendar_name
    parts = code.split('_')
    if parts.length > 2
      "#{parts[0]} #{parts[1]}"
    else
      code
    end
  end
end
