class Student < ActiveRecord::Base
  validates_presence_of :first_name
  validates_uniqueness_of :card_code, allow_nil: true
   #TODO uniq card, email

  def display_name
    "#{first_name} #{last_name}"
  end
end
