class PaymentPlan < ActiveRecord::Base
  OTHER = "OTRO"
  SINGLE_CLASS = "CLASE"

  def other?
    self.code == OTHER
  end

  def price_or_fallback(amount)
    self.other? ? amount : self.price
  end

  def requires_student_pack_for_class
    self.code != SINGLE_CLASS
  end
end
