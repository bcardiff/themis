class PaymentPlan < ActiveRecord::Base
  OTHER = "OTRO"

  def other?
    self.code == OTHER
  end

  def price_or_fallback(amount)
    self.other? ? amount : self.price
  end
end
