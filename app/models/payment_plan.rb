#
# Algunos planes de pago tienen significado especial. Estos deberían tener una
# `description` dado por las constantes OTHER, SINGLE_CLASS, etc.
#
# Cuántas clases y por cuánto tiempo es válido un pack depende del valor de varias
# propiedades.
#
# (1) Si `single_class == true`, es una clase individual y se usa en el mes en curso.
#     Por lo general son clases que se usan en el dia
#
# Si `single_class == false` entonces se ven los campos `weekly_classes`, `weeks` y `due_date_months`.
#
# `due_date_months` indica cuántos meses dura el pack. Por lo general es `1`. Esto indica que
# termina en el mes actual. El valor `2` es el mes siguiente. O sea, es la cantidad de meses que dura el pack.
#
# (2) Si `weeks == nil` entonces se calcula cuántas semanas hay desde el inicio de este mes hasta el
#     el final del mes indicado por `due_date_months`. Esa cantidad de semanas se multiplica por `weekly_classes`
#     para determinar la cantidad de clases que corresponden a la compra del pack. En este caso dependerá del mes
#     en curso el valor exacto. `weeks == nil` suele darse en packs de 2 y 3 meses por simplificación.
#
# (3) Si `weeks != nil` entonces la cantidad de cursos corresponde exactamente a `weeks * weekly_classes`.
#     Este caso suele darse en packs de 1 mes y hay packs para meses de 3, 4 y 5 semanas.
#
# Ver `StudentPack.register_for` que es donde se detalla esta lógica.
#
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
