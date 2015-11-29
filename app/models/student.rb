class Student < ActiveRecord::Base
  has_many :activity_logs, as: :target
  has_many :student_course_logs
  has_many :cards, dependent: :destroy
  has_many :student_packs, dependent: :delete_all

  UNKOWN = "N/A"

  validates_presence_of :first_name
  validates_uniqueness_of :card_code, allow_nil: true
  validates_uniqueness_of :email, allow_nil: true

  before_validation :apply_format_card_code
  before_validation :nil_if_empty
  validate :avoid_changing_card_code
  validates_format_of :card_code, with: /SWC\/stu\/\d\d\d\d/, allow_nil: true
  validate do |student|
    cards.each do |card|
      next if card.valid?
      card.errors.full_messages.each do |msg|
        errors[:base] << msg
      end
    end
  end

  scope :autocomplete, -> (q) { where("first_name LIKE ? OR last_name LIKE ? OR card_code LIKE ? OR email LIKE ?", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%") }
  scope :missing_payment, -> (date) {
    where(id: StudentCourseLog.joins(:course_log).where(course_logs: { date: date.month_range}).missing_payment.select(:student_id))
  }

  def display_name
    "#{first_name} #{last_name}"
  end

  def autocomplete_display_name
    "#{display_name} (#{card_code || 'Sin Tarjeta'})"
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
    elsif md = /\d+/.match(code)
      "SWC/stu/#{md[0].to_s.rjust(4, '0')}"
    else
      raise "Invalid card format #{code}" unless code.nil?
    end
  end

  def self.import!(first_name, last_name, email, card_code)
    first_name, last_name, email, card_code = [first_name, last_name, email, card_code].map { |x| x.strip.blank? ? nil : x.strip }
    existing = find_by(email: email) if email
    existing ||= find_by_card(card_code) if card_code
    if existing == nil && email.blank? && card_code.blank?
      existing = find_by(first_name: first_name, last_name: last_name)
    end
    if existing
      existing.first_name = first_name || existing.first_name
      existing.last_name = last_name || existing.last_name
      existing.email = email || existing.email
      existing.card_code = card_code || existing.card_code
      existing.save!
    else
      self.create! first_name: first_name, last_name: last_name, email: email, card_code: card_code
    end
  end

  def update_as_guest!(first_name, last_name)
    if self.new_record?
      self.card_code = nil
      self.first_name = first_name || Student::UNKOWN
      self.last_name = last_name || Student::UNKOWN
      self.save!
    end
  end

  def update_as_new_card!(first_name, last_name, email, card_code)
    if self.new_record? || self.first_name == Student::UNKOWN || self.email == nil
      self.first_name = first_name
      self.last_name = last_name
      self.email = email
    end

    formatted_card_code = Student.format_card_code(card_code) rescue nil
    if !formatted_card_code.blank? && self.cards.where(code: formatted_card_code).empty?
      self.cards.build(code: formatted_card_code)
    end

    if self.card_code == nil
      self.card_code = card_code
    end
    self.save!
  end

  def merge!(old_student)
    [Card, StudentCourseLog, StudentPack, TeacherCashIncomes].each do |type|
      type.where(student_id: old_student.id).update_all(student_id: self.id)
    end

    ActivityLog.where(target_type: 'Student', target_id: old_student.id).update_all(target_id: self.id)
    ActivityLog.where(related_type: 'Student', related_id: old_student.id).update_all(related_id: self.id)
  end

  def last_student_pack
    student_packs.where("due_date < ?", Date.today).order(due_date: :desc).first
  end

  def pending_payments_count(date_range = nil)
    if date_range
      self.student_course_logs.missing_payment.joins(:course_log).between(date_range).count
    else
      self.student_course_logs.missing_payment.count
    end
  end

  private

  def apply_format_card_code
    self.card_code = self.class.format_card_code(self.card_code)
  end

  def nil_if_empty
    self.card_code = nil unless self.card_code.present?
    self.email = nil unless self.email.present?
  end

  def avoid_changing_card_code
    if self.card_code_changed? && !self.card_code_was.blank?
      errors.add(:card_code, "was already set")
    end
  end
end
