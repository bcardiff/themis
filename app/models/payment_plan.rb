class PaymentPlan < ActiveRecord::Base
  OTHER = "OTRO"

  def other?
    self.code == OTHER
  end
end
