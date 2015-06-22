class Student < ActiveRecord::Base
  has_many :activity_logs, as: :target

  UNKOWN = "N/A"

  validates_presence_of :first_name
  validates_uniqueness_of :card_code, allow_nil: true
  validates_uniqueness_of :email, allow_nil: true

  before_validation :apply_format_card_code
  before_validation :nil_if_empty
  validate :avoid_changing_card_code
  validates_format_of :card_code, with: /SWC\/stu\/\d\d\d\d/, allow_nil: true

  def display_name
    "#{first_name} #{last_name}"
  end

  def self.find_by_card(code)
    where(card_code: format_card_code(code)).take
  end

  def self.find_or_initialize_by_card(code)
    find_or_initialize_by(card_code: format_card_code(code))
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
