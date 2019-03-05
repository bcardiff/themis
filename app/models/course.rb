class Course < ActiveRecord::Base
  has_many :course_logs
  belongs_to :place
  belongs_to :track

  validates_presence_of :weekday, :valid_since

  scope :ongoing, -> (date) { where('valid_until IS NULL or valid_until >= ?', date).where('valid_since <= ?', date).where(weekday: date.wday) }
  scope :ongoing_or_future, -> { where('valid_until IS NULL or valid_until >= ?', School.today) }
  scope :with_course_kind, -> (kinds) { joins(:track).where(tracks: {course_kind: kinds}) }

  def future?
    School.today < self.valid_since
  end

  def description(*components)
    parts = (components || []).map do |part_name|
      case part_name
      when :track
        track.name
      when :short_track
        track.code.split('_').join(' ')
      when :weekday
        "#{I18n.t('date.day_names')[weekday].titleize}#{" mañana" if start_time.hour <= 12}"
      when :time
        short_time
      when :place
        place.name if place && place.name != School.description
      end
    end

    parts.compact.join(' - ')
  end

  def short_time
    "#{self.start_time.hour}hs"
  end

  def css_prefix
    "#{track.css_prefix} #{hashtag.try &:underscore}"
  end
end
