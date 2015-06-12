class Student < ActiveRecord::Base
  has_many :activity_logs, as: :target

  UNKOWN = "N/A"

  validates_presence_of :first_name
  validates_uniqueness_of :card_code, allow_nil: true
  validates_uniqueness_of :email, allow_nil: true

  before_validation :apply_format_card_code
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
    if md = /\d+/.match(code)
      "SWC/stu/#{md[0].to_s.rjust(4, '0')}"
    else
      raise "Invalid card format #{code}" unless code.nil?
    end
  end

  def self.import!(first_name, last_name, email, card_code)
    first_name, last_name, email, card_code = [first_name, last_name, email, card_code].map { |x| x.strip.blank? ? nil : x.strip }
    self.create! first_name: first_name, last_name: last_name, email: email, card_code: card_code
  end

  private

  def apply_format_card_code
    self.card_code = self.class.format_card_code(self.card_code)
  end
end
