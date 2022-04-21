class PaymentPlan < ActiveRecord::Base
  OTHER = "OTRO"
  SINGLE_CLASS = "CLASE"
  SINGLE_CLASS_FREE = "CLASE_BONIFICADA"
  SINGLE_CLASS_ROOTS = "ROOTS__CLASE"
  SINGLE_CLASS_AFRO = "AFRO__CLASE"

  validates :price, numericality: true

  scope :active, -> { where("deleted_at IS NULL") }
  scope :single_class_payment_plans, -> { where(code: [SINGLE_CLASS, SINGLE_CLASS_AFRO, SINGLE_CLASS_ROOTS, SINGLE_CLASS_FREE]) }
  scope :reference_single_class_payment_plans, -> { where(code: [SINGLE_CLASS, SINGLE_CLASS_AFRO, SINGLE_CLASS_ROOTS]) }

  def other?
    self.code == OTHER
  end

  def single_class?
    self.code == SINGLE_CLASS || self.code == SINGLE_CLASS_ROOTS || self.code == SINGLE_CLASS_AFRO || self.code == SINGLE_CLASS_FREE
  end

  def self.single_class
    find_by(code: SINGLE_CLASS)
  end

  def self.single_class_by_kind
    reference_single_class_payment_plans.all.index_by &:course_match
  end

  def price_or_fallback(amount)
    self.other? ? amount : self.price
  end

  def requires_student_pack_for_class
    !self.single_class?
  end

  def notify_purchase?
    !self.other? && !self.single_class?
  end

  def mailer_description
    description.downcase
  end

  def self.updatable_prices
    PaymentPlan.active.order(:order, :price)
      .to_a.select { |p| !p.other? && p.code != SINGLE_CLASS_FREE }
  end
end
