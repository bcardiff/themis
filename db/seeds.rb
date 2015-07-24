# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def track(code)
  Track.find_or_create_by(code: code).tap do |track|
    track.save!
  end
end

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
teacher 'Majo', fee: 0
teacher 'Brian', fee: 0
teacher 'Otro', fee: 0

caballito = place Place::CABALLITO, address: "Rivadavia 4127", link: "https://goo.gl/maps/phcr8"
colmegna = place "Colmegna Spa Urbano", address: "Sarmiento 839", link: "http://goo.gl/sTPxUh"
la_huella = place "La Huella", address: "Bulnes 892", link: "http://goo.gl/kT1ElX"
vera = place "Oliverio Girondo Espacio Cultural", address: "Vera 574", link: "http://goo.gl/VgcPe6"
sendas = place "Sendas del Sol", address: "Lambaré 990", link: "http://goo.gl/BAZsox"
ibera = place "Pororoca", address: "Iberá 2358", link: "http://goo.gl/Rosg56"
chez_manuel = place "Chez Manuel", address: "Paraná y Córdoba", link: "#"
danzas = place "Academia Integral de Danzas", address: "Av. Scalabrini Ortiz 885", link: "http://goo.gl/TyVh85"



course "CH_PRIN_MIE", name: "Charleston - Principiantes - Miércoles Sendas", weekday: 3, track: track("CH_PRIN"), place: sendas, start_time: '20:30'
course "CH_AVAN_MIE", name: "Charleston - Avanzados - Miércoles Sendas", weekday: 3, track: track("CH_AVAN"), place: sendas, start_time: '20:30'

course "LH_INT1_LUN", name: "Lindy Hop - Intermedios 1 - Lunes colmegna", weekday: 1, track: track("LH_INT1"), place: colmegna, start_time: '20:00'
course "LH_INT1_MAR", name: "Lindy Hop - Intermedios 1 - Martes La Fragua", weekday: 2, track: track("LH_INT1"), place: caballito, start_time: '19:00'
course "LH_INT1_MIE", name: "Lindy Hop - Intermedios 1 - Miércoles Vera", weekday: 3, track: track("LH_INT1"), place: vera, start_time: '19:00'
course "LH_INT1_JUE", name: "Lindy Hop - Intermedios 1 - Jueves Vera", weekday: 4, track: track("LH_INT1"), place: vera, start_time: '19:00'
course "LH_INT1_VIE", name: "Lindy Hop - Intermedios 1 - Viernes Malcom", weekday: 5, valid_until: Date.new(2015,5,31), track: track("LH_INT1")
course "LH_INT1_VIE_PARANA", name: "Lindy Hop - Intermedios 1 - Viernes Paraná y Córdoba", weekday: 5, track: track("LH_INT1"), place: chez_manuel, start_time: '20:30'
course "LH_INT1_VIE_IBERA", name: "Lindy Hop - Intermedios 1 - Viernes Iberá", weekday: 5, track: track("LH_INT1"), place: ibera, start_time: '20:00'
course "LH_INT1_SAB", name: "Lindy Hop - Intermedios 1 - Sábados Sc", weekday: 6, valid_since: Date.new(2015,6,1), track: track("LH_INT1"), place: danzas, start_time: '17:00'

course "LH_INT2_LUN", name: "Lindy Hop - Intermedios 2 - Lunes colmegna", weekday: 1, track: track("LH_INT2"), place: colmegna, start_time: '19:00'
course "LH_INT2_JUE", name: "Lindy Hop - Intermedios 2 - Jueves Vera", weekday: 4, track: track("LH_INT2"), place: vera, start_time: '20:00'
course "LH_INT2_SAB", name: "Lindy Hop - Intermedios 2 - Sábados Sc", weekday: 6, valid_since: Date.new(2015,6,1), track: track("LH_INT2"), place: danzas, start_time: '18:00'

course "LH_PRIN_LUN", name: "Lindy Hop - Principiantes - Lunes colmegna", weekday: 1, track: track("LH_PRIN"), place: colmegna, start_time: '19:00'
course "LH_PRIN_MAR2", name: "Lindy Hop - Principiantes - Martes La Fragua", weekday: 2, place: caballito, track: track("LH_PRIN"), place: caballito, start_time: '20:00'
course "LH_PRIN_MIE2", name: "Lindy Hop - Principiantes - Miércoles Vera", weekday: 3, track: track("LH_PRIN"), place: vera, start_time: '19:00'
course "LH_PRIN_MIE", name: "Lindy Hop - Principiantes - Miércoles colmegna", weekday: 3, valid_until: Date.new(2015,5,31), track: track("LH_PRIN"), place: colmegna
course "LH_PRIN_JUE", name: "Lindy Hop - Principiantes - Jueves Vera", weekday: 4, track: track("LH_PRIN"), place: vera, start_time: '20:00'
course "LH_PRIN_VIE", name: "Lindy Hop - Principiantes - Viernes Iberá", weekday: 5, track: track("LH_PRIN"), place: ibera, start_time: '19:00'
course "LH_PRIN_SAB", name: "Lindy Hop - Principiantes - Sábados Sc", weekday: 6, track: track("LH_PRIN"), place: danzas, start_time: '18:00'

course "LH_AVAN_LUN", name: "Lindy Hop - Avanzados - Lunes colmegna", weekday: 1, track: track("LH_AVAN"), place: colmegna, start_time: '20:00'

course "TP_PRIN_MAR", name: "Tap - Principiantes - Martes La huella", weekday: 2, valid_until: Date.new(2015,5,31), track: track("TP_PRIN"), place: la_huella
course "TP_PRIN_MIE", name: "Tap - Principiantes - Miércoles Medrano", weekday: 3, valid_until: Date.new(2015,5,31), track: track("TP_PRIN")
course "TP_PRIN_VIE", name: "Tap - Principiantes - Viernes La huella", weekday: 5, valid_since: Date.new(2015,6,1), track: track("TP_PRIN"), place: la_huella, start_time: '19:00'

course "TP_INT1_MAR", name: "Tap - Intermedios 1 - Martes La huella", weekday: 2, track: track("TP_INT1"), place: la_huella, start_time: '18:00'
course "TP_INT1_VIE", name: "Tap - Intermedios 1 - Viernes La huella", weekday: 5, valid_since: Date.new(2015,6,1), track: track("TP_INT1"), place: la_huella, start_time: '20:00'

course "LIMBO_1", name: "Limbo 1 - Principiantes - Miércoles Sendas", weekday: 3, valid_since: Date.new(2015,7,1), track: track("LH_INT1"), place: sendas, start_time: '20:30', hashtag: "LIMBO"
course "LIMBO_2", name: "Limbo 2 - Intermedios 1 - Miércoles Sendas", weekday: 3, valid_since: Date.new(2015,7,1), track: track("LH_INT2"), place: sendas, start_time: '19:30', hashtag: "LIMBO"
course "LIMBO_3", name: "Limbo 3 - Intermedios 2 - Viernes Vera", weekday: 5, valid_since: Date.new(2015,7,1), track: track("LH_AVAN"), place: vera, start_time: '19:00', hashtag: "LIMBO"


payment_plan "3_MESES", description: "3 Meses 1 x Semana $550", price: 550, weekly_classes: 1
payment_plan "3_X_SEMANA", description: "Mensual 3 x Semana $500", price: 500, weekly_classes: 3
payment_plan "2_X_SEMANA", description: "Mensual 2 x Semana $400", price: 400, weekly_classes: 2
payment_plan "1_X_SEMANA_3", description: "Mensual 1 x Semana (3 c) $180", price: 180, weekly_classes: 1
payment_plan "1_X_SEMANA_4", description: "Mensual 1 x Semana (4 c) $250", price: 250, weekly_classes: 1
payment_plan "1_X_SEMANA_5", description: "Mensual 1 x Semana (5 c) $300", price: 300, weekly_classes: 1
payment_plan "CLASE", description: "Clase suelta $70", price: 70, weekly_classes: 1
payment_plan PaymentPlan::OTHER, description: "Otro (monto a continuación)", price: 0, weekly_classes: 1



