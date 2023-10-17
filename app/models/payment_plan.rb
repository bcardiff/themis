class PaymentPlan < ActiveRecord::Base
  OTHER = 'OTRO'.freeze
  SINGLE_CLASS = 'CLASE'.freeze
  SINGLE_CLASS_FREE = 'CLASE_BONIFICADA'.freeze
  SINGLE_CLASS_ROOTS = 'ROOTS__CLASE'.freeze
  SINGLE_CLASS_AFRO = 'AFRO__CLASE'.freeze

  validates :price, numericality: true

  scope :single_class_payment_plans, lambda {
                                       where(code: [SINGLE_CLASS, SINGLE_CLASS_AFRO, SINGLE_CLASS_ROOTS, SINGLE_CLASS_FREE])
                                     }
  scope :reference_single_class_payment_plans, -> { where(code: [SINGLE_CLASS, SINGLE_CLASS_AFRO, SINGLE_CLASS_ROOTS]) }

  def other?
    code == OTHER
  end

  def single_class?
    code == SINGLE_CLASS || code == SINGLE_CLASS_ROOTS || code == SINGLE_CLASS_AFRO || code == SINGLE_CLASS_FREE
  end

  def self.single_class
    find_by(code: SINGLE_CLASS)
  end

  def self.single_class_by_kind
    reference_single_class_payment_plans.all.index_by(&:course_match)
  end

  def price_or_fallback(amount)
    other? ? amount : price
  end

  def requires_student_pack_for_class
    !single_class?
  end

  def notify_purchase?
    !other? && !single_class?
  end

  def mailer_description
    description.downcase
  end

  def self.updatable_prices
    PaymentPlan.all.order(:order, :price)
      .to_a.select { |p| !p.other? && p.code != SINGLE_CLASS_FREE }
  end
end
