class Course < ActiveRecord::Base
  has_many :course_logs
  belongs_to :place
  belongs_to :track

  validates_presence_of :weekday, :valid_since

  scope :ongoing, -> { where(valid_until: nil) }

  def calendar_name
    parts = code.split('_')
    if parts.length > 2
      "#{parts[0]} #{parts[1]}"
    else
      code
    end
  end

  def room_name
    res = name.split('-')[0..1].join('-')
    res += " - #{place.name}" if place && place.name != School.description
    res
  end
end
