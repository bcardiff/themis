# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def course(code, attributes)
  Course.find_or_create_by(code: code).tap do |course|
    course.valid_since = Date.new(2015,5,1)
    attributes.each do |key, value|
      course.send "#{key}=", value
    end
    course.save!
  end
end

def payment_plan(code, attributes)
  PaymentPlan.find_or_create_by(code: code).tap do |plan|
    attributes.each do |key, value|
      plan.send "#{key}=", value
    end
    plan.save!
  end
end

def teacher(name, attributes)
  Teacher.find_or_create_by(name: name).tap do |teacher|
    attributes.each do |key, value|
      teacher.send "#{key}=", value
    end
    teacher.save!
  end
end

def place(name, attributes)
  Place.find_or_create_by(name: name).tap do |place|
    attributes.each do |key, value|
      place.send "#{key}=", value
    end
    place.save!
  end
end

teacher 'Mariel', fee: 230
teacher 'Manuel', fee: 230
teacher 'Juani', fee: 230
teacher 'Candela', fee: 175
teacher 'Mariano', fee: 175
teacher 'Celeste', fee: 175
teacher 'Nanchi', fee: 175
teacher 'Sol', fee: 175

caballito = place Place::CABALLITO, address: 'Rivadavia 4127'

course "CH_PRIN_MIE", name: "Charleston - Principiantes - Miércoles Sendas", weekday: 3
course "CH_AVAN_MIE", name: "Charleston - Avanzados - Miércoles Sendas", weekday: 3

course "LH_INT1_LUN", name: "Lindy Hop - Intermedios 1 - Lunes colmegna", weekday: 1
course "LH_INT1_MAR", name: "Lindy Hop - Intermedios 1 - Martes La Fragua", weekday: 2, place: caballito
course "LH_INT1_MIE", name: "Lindy Hop - Intermedios 1 - Miércoles Vera", weekday: 3
course "LH_INT1_JUE", name: "Lindy Hop - Intermedios 1 - Jueves Vera", weekday: 4
course "LH_INT1_VIE", name: "Lindy Hop - Intermedios 1 - Viernes Malcom", weekday: 5, valid_until: Date.new(2015,5,31)
course "LH_INT1_VIE_PARANA", name: "Lindy Hop - Intermedios 1 - Viernes Paraná y Córdoba", weekday: 5 # new?
course "LH_INT1_VIE_IBERA", name: "Lindy Hop - Intermedios 1 - Viernes Iberá", weekday: 5 # new?
course "LH_INT1_SAB", name: "Lindy Hop - Intermedios 1 - Sábados Sc", weekday: 6, valid_since: Date.new(2015,6,1)

course "LH_INT2_LUN", name: "Lindy Hop - Intermedios 2 - Lunes colmegna", weekday: 1
course "LH_INT2_JUE", name: "Lindy Hop - Intermedios 2 - Jueves Vera", weekday: 4
course "LH_INT2_SAB", name: "Lindy Hop - Intermedios 2 - Sábados Sc", weekday: 6, valid_since: Date.new(2015,6,1)

course "LH_PRIN_LUN", name: "Lindy Hop - Principiantes - Lunes colmegna", weekday: 1
course "LH_PRIN_MAR2", name: "Lindy Hop - Principiantes - Martes La Fragua", weekday: 2, place: caballito
course "LH_PRIN_MIE2", name: "Lindy Hop - Principiantes - Miércoles Vera", weekday: 3
course "LH_PRIN_MIE", name: "Lindy Hop - Principiantes - Miércoles colmegna", weekday: 3, valid_until: Date.new(2015,5,31)
course "LH_PRIN_JUE", name: "Lindy Hop - Principiantes - Jueves Vera", weekday: 4
course "LH_PRIN_VIE", name: "Lindy Hop - Principiantes - Viernes Iberá", weekday: 5
course "LH_PRIN_SAB", name: "Lindy Hop - Principiantes - Sábados Sc", weekday: 6

course "LH_AVAN_LUN", name: "Lindy Hop - Avanzados - Lunes colmegna", weekday: 1

course "TP_PRIN_MAR", name: "Tap - Principiantes - Martes La huella", weekday: 2, valid_until: Date.new(2015,5,31)
course "TP_PRIN_MIE", name: "Tap - Principiantes - Miércoles Medrano", weekday: 3, valid_until: Date.new(2015,5,31)
course "TP_PRIN_VIE", name: "Tap - Principiantes - Viernes La huella", weekday: 5, valid_since: Date.new(2015,6,1)

course "TP_INT1_MAR", name: "Tap - Intermedios 1 - Martes La huella", weekday: 2
course "TP_INT1_VIE", name: "Tap - Intermedios 1 - Viernes La huella", weekday: 5, valid_since: Date.new(2015,6,1)

payment_plan "3_MESES", description: "3 Meses 1 x Semana $550", price: 550, weekly_classes: 1
payment_plan "2_X_SEMANA", description: "Mensual 2 x Semana $350", price: 350, weekly_classes: 2
payment_plan "1_X_SEMANA_4", description: "Mensual 1 x Semana (4 c) $250", price: 250, weekly_classes: 1
payment_plan "1_X_SEMANA_5", description: "Mensual 1 x Semana (5 c) $300", price: 300, weekly_classes: 1
payment_plan "CLASE", description: "Clase suelta $70", price: 70, weekly_classes: 1
payment_plan PaymentPlan::OTHER, description: "Otro (monto a continuación)", price: 0, weekly_classes: 1



