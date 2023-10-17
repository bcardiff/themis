class Student < ActiveRecord::Base
  has_many :activity_logs, as: :target
  has_many :student_course_logs
  has_many :cards
  has_many :student_packs

  UNKOWN = 'N/A'.freeze

  validates_presence_of :first_name
  validates_uniqueness_of :card_code, allow_nil: true
  validates_uniqueness_of :email, allow_nil: true

  before_validation :apply_format_card_code
  before_validation :nil_if_empty
  validate :avoid_changing_card_code
  validates_format_of :card_code, with: %r{SWC/stu/\d\d\d\d}, allow_nil: true
  validate do |_student|
    cards.each do |card|
      next if card.valid?

      card.errors.full_messages.each do |msg|
        errors[:base] << msg
      end
    end
  end

  scope :autocomplete, lambda { |q|
                         where('first_name LIKE ? OR last_name LIKE ? OR card_code LIKE ? OR email LIKE ?', "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%")
                       }
  scope :missing_payment, lambda { |date|
    where(id: StudentCourseLog.joins(:course_log).where(course_logs: { date: date.month_range }).missing_payment.select(:student_id))
  }

  before_save :ensure_card
  before_save :update_comment_at
  belongs_to :comment_by, class_name: 'User'

  def display_name
    "#{first_name} #{last_name}"
  end

  def autocomplete_display_name
    "#{display_name} (#{card_code || no_card_text})"
  end

  def self.find_by_card(code)
    where(card_code: format_card_code(code)).take
  end

  def self.find_or_initialize_by_card(code)
    find_or_initialize_by(card_code: format_card_code(code))
  end

  def self.find_or_initialize_by_email(email)
    if email.blank?
      Student.new email: nil
    else
      Student.find_or_initialize_by email: email
    end
  end

  def self.format_card_code(code)
    if code.blank?
      nil
    elsif (md = /\d+/.match(code))
      "SWC/stu/#{md[0].to_s.rjust(4, '0')}"
    else
      raise "Invalid card format #{code}" unless code.nil?
    end
  end

  def self.import!(first_name, last_name, email, card_code)
    first_name, last_name, email, card_code = [first_name, last_name, email, card_code].map do |x|
      x.strip.blank? ? nil : x.strip
    end
    existing = find_by(email: email) if email
    existing ||= find_by_card(card_code) if card_code
    existing = find_by(first_name: first_name, last_name: last_name) if existing.nil? && email.blank? && card_code.blank?
    if existing
      existing.first_name = first_name || existing.first_name
      existing.last_name = last_name || existing.last_name
      existing.email = email || existing.email
      existing.card_code = card_code || existing.card_code
      existing.save!
    else
      create! first_name: first_name, last_name: last_name, email: email, card_code: card_code
    end
  end

  def update_as_guest!(first_name, last_name)
    return unless new_record?

    self.card_code = nil
    self.first_name = first_name || Student::UNKOWN
    self.last_name = last_name || Student::UNKOWN
    save!
  end

  def update_as_new_card!(first_name, last_name, email, card_code)
    if new_record? || self.first_name == Student::UNKOWN || self.email.nil?
      self.first_name = first_name
      self.last_name = last_name
      self.email = email
    end

    formatted_card_code = begin
      Student.format_card_code(card_code)
    rescue StandardError
      nil
    end
    cards.build(code: formatted_card_code) if !formatted_card_code.blank? && cards.where(code: formatted_card_code).empty?

    self.card_code = card_code if self.card_code.nil?
    save!
  end

  def merge!(old_student)
    [Card, StudentCourseLog, StudentPack, TeacherCashIncome].each do |type|
      type.where(student_id: old_student.id).update_all(student_id: id)
    end

    ActivityLog.where(target_type: 'Student', target_id: old_student.id).update_all(target_id: id)
    ActivityLog.where(related_type: 'Student', related_id: old_student.id).update_all(related_id: id)
  end

  before_destroy do
    [TeacherCashIncome, StudentCourseLog, StudentPack, Card].each do |type|
      type.where(student_id: id).delete_all
    end

    ActivityLog.where(target_type: 'Student', target_id: id).delete_all
    ActivityLog.where(related_type: 'Student', related_id: id).delete_all
  end

  def last_student_pack
    student_packs.where('due_date < ?', School.today).order(due_date: :desc).first
  end

  def pending_payments_count(date_range = nil)
    if date_range
      student_course_logs.missing_payment.joins(:course_log).between(date_range).count
    else
      student_course_logs.missing_payment.count
    end
  end

  def ensure_card
    return unless card_code && cards.where(code: card_code).empty?

    cards.build(code: card_code)
  end

  private

  def apply_format_card_code
    self.card_code = self.class.format_card_code(card_code)
  end

  def nil_if_empty
    self.card_code = nil unless card_code.present?
    self.email = nil unless email.present?
  end

  def avoid_changing_card_code
    return unless card_code_changed? && !card_code_was.blank?

    errors.add(:card_code, 'was already set')
  end

  def update_comment_at
    return unless comment_changed?

    if comment.blank?
      self.comment_at = nil
      self.comment = nil
      self.comment_by = nil
    else
      self.comment_at = Time.now
    end
  end

  def no_card_text
    case Settings.branch
    when 'sheffield'
      'No Card'
    else
      'Sin Tarjeta'
    end
  end
end
