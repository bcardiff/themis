class Card < ActiveRecord::Base
  belongs_to :student

  validates_uniqueness_of :code, message: 'Tarjeta %<value>s ya fue entregada'
  validates_format_of :code, with: %r{SWC/stu/\d\d\d\d}
end
