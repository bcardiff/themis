class PaymentPlan < ActiveRecord::Base
  OTHER = "OTRO"
  SINGLE_CLASS = "CLASE"

  def other?
    self.code == OTHER
  end

  def single_class?
    self.code == SINGLE_CLASS
  end

  def self.single_class
    find_by(code: SINGLE_CLASS)
  end

  def price_or_fallback(amount)
    self.other? ? amount : self.price
  end

  def requires_student_pack_for_class
    self.code != SINGLE_CLASS
  end

  def notify_purchase?
    !self.other? && !self.single_class?
  end

  def mailer_description
    # remove prices
    description[/[^\$]*/].strip.downcase
  end
end
