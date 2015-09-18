class Card < ActiveRecord::Base
  belongs_to :student

  validates_uniqueness_of :code, message: "Tarjeta %{value} ya fue entregada"
  validates_format_of :code, with: /SWC\/stu\/\d\d\d\d/

end
