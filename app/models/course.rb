class Course < ActiveRecord::Base
  has_many :course_logs
  belongs_to :place
  belongs_to :track

  validates_presence_of :weekday, :valid_since

  scope :ongoing, -> (date) { where('valid_until IS NULL or valid_until >= ?', date).where('valid_since <= ?', date).where(weekday: date.wday) }
  scope :ongoing_or_future, -> { where('valid_until IS NULL or valid_until >= ?', School.today) }

  def future?
    School.today < self.valid_since
  end

  def name_with_wday_as_context
    track.code.split('_').join(' ')
  end

  def room_name
    res = name.split('-')[0..-2].join('-')
    res += " - #{place.name}" if place && place.name != School.description
    res
  end

  def name_with_track_as_context
    code.sub("#{track.code}_", "")
  end
end
