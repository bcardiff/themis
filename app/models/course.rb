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

  def name_with_wday_as_context(options = {})
    options.reverse_merge!(show_time: true)

    res = track.code.split('_').join(' ')
    res += "#{'*' if self.hashtag}"
    res += " #{self.short_time}" if options[:show_time]
    res
  end

  def room_name(options = {})
    options.reverse_merge!(show_time: true)

    res = name.split('-')[0..-2].join('-')
    res += " - #{place.name}" if place && place.name != School.description
    res += " (#{self.short_time})" if options[:show_time]
    res
  end

  def name_and_time
    "#{self.name} #{self.short_time}"
  end

  def short_time
    "#{self.start_time.hour}hs"
  end

  def name_with_track_as_context
    code.sub("#{track.code}_", "")
  end

  def css_prefix
    "#{track.css_prefix} #{hashtag.try &:underscore}"
  end
end
