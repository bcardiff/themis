class Course < ActiveRecord::Base
  has_many :course_logs
  belongs_to :place
  belongs_to :track

  validates_presence_of :weekday, :valid_since, :track, :start_time, :place

  validates :code, presence: true, uniqueness: true, format: { with: /\A[\w\_]+\z/ }

  scope :ongoing, lambda { |date|
                    where('valid_until IS NULL or valid_until >= ?', date).where('valid_since <= ?', date).where(weekday: date.wday)
                  }
  scope :ongoing_or_future, -> { where('valid_until IS NULL or valid_until >= ?', School.today) }
  scope :with_course_kind, ->(kinds) { joins(:track).where(tracks: { course_kind: kinds }) }

  def future?
    School.today < valid_since
  end

  def can_destroy?
    course_logs.count.zero?
  end

  def description(*components)
    parts = (components || []).map do |part_name|
      case part_name
      when :track
        "#{track.name}#{" - #{hashtag}" if hashtag.present?}"
      when :short_track
        "#{track.code.split('_').join(' ')}#{" #{hashtag}" if hashtag.present?}"
      when :weekday
        "#{I18n.t('date.day_names')[weekday].titleize}#{' mañana' if start_time.hour <= 12}"
      when :time
        short_time
      when :place
        place.name if place && place.name != School.description
      end
    end

    parts.compact.join(' - ')
  end

  def short_time
    "#{start_time.hour}hs"
  end

  def self.next_code(track, wday)
    prefix = "#{track.code}_#{I18n.t('date.abbr_day_names')[wday].upcase}"
    used_codes = Course.where("code LIKE '#{prefix}%'").pluck(:code)

    index = 1
    res = prefix

    while used_codes.include?(res)
      index += 1
      res = "#{prefix}#{index}"
    end

    res
  end
end
