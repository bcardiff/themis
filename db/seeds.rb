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
    teacher.fee = 0 if teacher.new_record?
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

teacher 'Mariel', cashier: true, priority: 1
teacher 'Manuel', cashier: true, priority: 1
teacher 'Juani', priority: 1
teacher 'Candela', priority: 0, deleted_at: Date.new(2016,2,1)
teacher 'Mariano', priority: 2
teacher 'Celeste', priority: 2
teacher 'Nanchi', priority: 2
teacher 'Sol', priority: 2
teacher 'Majo', priority: 0
teacher 'Brian', cashier: true, priority: 0
teacher 'Otro', priority: 4
teacher 'Martina', cashier: true, priority: 0
teacher 'Blake', cashier: true, priority: 0
teacher 'Belu', cashier: true, priority: 0
teacher 'Lala', cashier: true, priority: 0
teacher 'Victoria', priority: 2
teacher 'Farru', priority: 3
teacher 'Soledad', priority: 3
teacher 'Edu', priority: 3
teacher 'Eliana', priority: 3
teacher 'Agustín', priority: 3

caballito = place Place::CABALLITO, address: "Rivadavia 4127", link: "https://goo.gl/maps/phcr8"
colmegna = place "Colmegna Spa Urbano", address: "Sarmiento 839", link: "http://goo.gl/sTPxUh"
la_huella = place "La Huella", address: "Bulnes 892", link: "http://goo.gl/kT1ElX"
vera = place "Oliverio Girondo Espacio Cultural", address: "Vera 574", link: "http://goo.gl/VgcPe6"
sendas = place "Sendas del Sol", address: "Lambaré 990", link: "http://goo.gl/BAZsox"
ibera = place "Pororoca", address: "Iberá 2385", link: "http://goo.gl/Rosg56"
chez_manuel = place "Chez Manuel", address: "Paraná y Córdoba", link: "#"
danzas = place "Academia Integral de Danzas", address: "Av. Scalabrini Ortiz 885", link: "http://goo.gl/TyVh85"
swing_city = place "Swing City", address: "Av. Scalabrini Ortiz 103", link: "https://goo.gl/maps/SjATQh9YyVP2"



course "AJ_PRIN_LUN", name: "Authentic Jazz - Principiantes - Lunes", weekday: 1, valid_since: Date.new(2016,4,1), track: track("AJ_PRIN"), place: swing_city, start_time: '19:00'
course "AJ_PRIN_LUN2", name: "Authentic Jazz - Principiantes - Lunes mañana", weekday: 1, valid_since: Date.new(2017,3,1), track: track("AJ_PRIN"), place: swing_city, start_time: '10:00'
course "AJ_AVAN_MAR", name: "Authentic Jazz - Avanzados - Martes", weekday: 2, track: track("AJ_AVAN"), place: swing_city, valid_since: Date.new(2017,1,1), start_time: '19:00'
course "AJ_PRIN_MIE", name: "Authentic Jazz - Principiantes - Miércoles", weekday: 3, track: track("AJ_PRIN"), place: swing_city, start_time: '19:00'
course "AJ_AVAN_MIE", name: "Authentic Jazz - Avanzados - Miércoles", weekday: 3, track: track("AJ_AVAN"), place: swing_city, start_time: '20:00', valid_until: Date.new(2016,12,31)
course "AJ_INT1_MIE", name: "Authentic Jazz - Intermedios 1 - Miércoles", weekday: 3, track: track("AJ_INT1"), place: swing_city, valid_since: Date.new(2017,1,1), start_time: '20:00'
course "AJ_AVAN_SAB", name: "Authentic Jazz - Avanzados - Sábados", weekday: 6, valid_since: Date.new(2016,1,1), track: track("AJ_AVAN"), place: swing_city, start_time: '17:00'

course "LH_INT1_LUN", name: "Lindy Hop - Intermedios 1 - Lunes", weekday: 1, track: track("LH_INT1"), place: swing_city, start_time: '20:00'
course "LH_INT1_MAR", name: "Lindy Hop - Intermedios 1 - Martes", weekday: 2, track: track("LH_INT1"), place: swing_city, start_time: '19:00'
course "LH_INT1_MIE", name: "Lindy Hop - Intermedios 1 - Miércoles", weekday: 3, track: track("LH_INT1"), place: swing_city, start_time: '19:00'
course "LH_INT1_JUE", name: "Lindy Hop - Intermedios 1 - Jueves", weekday: 4, track: track("LH_INT1"), place: swing_city, start_time: '19:00'
course "LH_INT1_VIE", name: "Lindy Hop - Intermedios 1 - Viernes Malcom", weekday: 5, valid_until: Date.new(2015,5,31), track: track("LH_INT1")
course "LH_INT1_VIE_PARANA", name: "Lindy Hop - Intermedios 1 - Viernes Paraná y Córdoba", weekday: 5, track: track("LH_INT1"), place: chez_manuel, start_time: '20:30', valid_until: Date.new(2015,8,2)
course "LH_INT1_VIE_IBERA", name: "Lindy Hop - Intermedios 1 - Viernes Iberá", weekday: 5, track: track("LH_INT1"), place: ibera, start_time: '20:00', valid_until: Date.new(2016, 3, 31)
course "LH_INT1_VIE_SC", name: "Lindy Hop - Intermedios 1 - Viernes", weekday: 5, valid_since: Date.new(2016,1,1), track: track("LH_INT1"), place: swing_city, start_time: '20:00'
course "LH_PRIN_VIE2", name: "Lindy Hop - Principiantes - Viernes", weekday: 5, valid_since: Date.new(2016,1,1), track: track("LH_INT1"), place: swing_city, start_time: '20:00'
course "LH_INT1_SAB", name: "Lindy Hop - Intermedios 1 - Sábados", weekday: 6, valid_since: Date.new(2015,6,1), track: track("LH_INT1"), place: swing_city, start_time: '17:00'

course "LH_INT2_LUN", name: "Lindy Hop - Intermedios 2 - Lunes", weekday: 1, track: track("LH_INT2"), place: swing_city, start_time: '19:00'
course "LH_INT2_JUE", name: "Lindy Hop - Intermedios 2 - Jueves", weekday: 4, track: track("LH_INT2"), place: swing_city, start_time: '20:00'
course "LH_INT2_SAB", name: "Lindy Hop - Intermedios 2 - Sábados", weekday: 6, valid_since: Date.new(2015,6,1), track: track("LH_INT2"), place: swing_city, start_time: '18:00'

course "LH_INT3_MAR", name: "Lindy Hop - Intermedios 3 - Martes", weekday: 2, valid_since: Date.new(2016,1,1), track: track("LH_INT3"), place: swing_city, start_time: '20:00'
course "LH_INT3_SAB", name: "Lindy Hop - Intermedios 3 - Sábados", weekday: 6, valid_since: Date.new(2016,10,7), track: track("LH_INT3"), place: swing_city, start_time: '16:00'

course "LH_PRIN_LUN", name: "Lindy Hop - Principiantes - Lunes", weekday: 1, track: track("LH_PRIN"), place: swing_city, start_time: '19:00'
course "LH_PRIN_LUN2", name: "Lindy Hop - Principiantes - Lunes mañana", weekday: 1, track: track("LH_PRIN"), place: swing_city, start_time: '11:00'
course "LH_PRIN_MAR2", name: "Lindy Hop - Principiantes - Martes", weekday: 2, track: track("LH_PRIN"), place: swing_city, start_time: '20:00'
course "LH_PRIN_MIE2", name: "Lindy Hop - Principiantes - Miércoles", weekday: 3, track: track("LH_PRIN"), place: swing_city, start_time: '20:00'
course "LH_PRIN_MIE", name: "Lindy Hop - Principiantes - Miércoles colmegna", weekday: 3, valid_until: Date.new(2015,5,31), track: track("LH_PRIN"), place: swing_city
course "LH_PRIN_JUE", name: "Lindy Hop - Principiantes - Jueves", weekday: 4, track: track("LH_PRIN"), place: swing_city, start_time: '20:00'
course "LH_PRIN_VIE", name: "Lindy Hop - Principiantes - Viernes Iberá", weekday: 5, track: track("LH_PRIN"), place: ibera, start_time: '19:00', valid_until: Date.new(2016, 3, 31)
course "LH_PRIN_VIE2", name: "Lindy Hop - Principiantes - Viernes", weekday: 5, valid_since: Date.new(2016,1,1), track: track("LH_PRIN"), place: swing_city, start_time: '19:00'
course "LH_PRIN_SAB", name: "Lindy Hop - Principiantes - Sábados", weekday: 6, track: track("LH_PRIN"), place: swing_city, start_time: '18:00'

course "LH_AVAN_LUN", name: "Lindy Hop - Avanzados - Lunes", weekday: 1, track: track("LH_AVAN"), place: swing_city, start_time: '20:00'
course "LH_AVAN_SAB", name: "Lindy Hop - Avanzados - Sábados", weekday: 6, valid_since: Date.new(2016,1,1), valid_until: Date.new(2016, 10, 2), track: track("LH_AVAN"), place: swing_city, start_time: '16:00'

course "LH_AVAN2_MAR", name: "Lindy Hop - Avanzados 2 - Martes", weekday: 2, valid_since: Date.new(2016,1,1), track: track("LH_AVAN2"), place: swing_city, start_time: '19:00', valid_until: Date.new(2016,8,31)

course "TP_PRIN_LUN", name: "Tap - Principiantes - Lunes", weekday: 1, valid_since: Date.new(2016,4,1), track: track("TP_PRIN"), place: swing_city, start_time: '20:00'
course "TP_PRIN_LUN2", name: "Tap - Principiantes - Lunes mañana", weekday: 1, valid_since: Date.new(2017,3,1), track: track("TP_PRIN"), place: swing_city, start_time: '10:00'
course "TP_PRIN_MAR", name: "Tap - Principiantes - Martes La huella", weekday: 2, valid_until: Date.new(2015,5,31), track: track("TP_PRIN"), place: la_huella
course "TP_PRIN_MAR2", name: "Tap - Principiantes - Martes", weekday: 2, valid_since: Date.new(2016,1,1), valid_until: Date.new(2016,12,31), track: track("TP_PRIN"), place: swing_city, start_time: '19:00'
course "TP_PRIN_MAR3", name: "Tap - Principiantes - Martes", weekday: 2, valid_since: Date.new(2017,1,1), track: track("TP_PRIN"), place: swing_city, start_time: '20:00'
course "TP_PRIN_MIE", name: "Tap - Principiantes - Miércoles Medrano", weekday: 3, valid_until: Date.new(2015,5,31), track: track("TP_PRIN")
course "TP_PRIN_VIE", name: "Tap - Principiantes - Viernes", weekday: 5, valid_since: Date.new(2015,6,1), track: track("TP_PRIN"), place: swing_city, start_time: '19:00'

course "TP_INT1_LUN", name: "Tap - Intermedios 1 - Lunes mañana", weekday: 1, track: track("TP_INT1"), place: swing_city, valid_until: Date.new(2017,3,1), start_time: '11:00'
course "TP_INT1_MAR", name: "Tap - Intermedios 1 - Martes", weekday: 2, track: track("TP_INT1"), place: swing_city, valid_until: Date.new(2016,12,31), start_time: '18:00'
course "TP_INT1_MAR2", name: "Tap - Intermedios 1 - Martes", weekday: 2, valid_since: Date.new(2017,1,1), track: track("TP_INT1"), place: swing_city, start_time: '19:00'
course "TP_INT1_VIE", name: "Tap - Intermedios 1 - Viernes", weekday: 5, valid_since: Date.new(2015,6,1), track: track("TP_INT1"), place: swing_city, start_time: '20:00'

course "TP_INT2_MAR", name: "Tap - Intermedios 2 - Martes", weekday: 2, track: track("TP_INT2"), place: swing_city, start_time: '18:00'

course "LIMBO_1", name: "Limbo 1 - Principiantes - Miércoles", weekday: 3, valid_since: Date.new(2015,7,1), track: track("LH_INT1"), place: swing_city, start_time: '20:00', hashtag: "LIMBO"
course "LIMBO_2", name: "Limbo 2 - Intermedios 1 - Miércoles", weekday: 3, valid_since: Date.new(2015,7,1), track: track("LH_INT2"), place: swing_city, start_time: '19:00', hashtag: "LIMBO"
course "LIMBO_3_JUE", name: "Limbo 3 - Intermedios 2 - Jueves", weekday: 4, valid_since: Date.new(2015,7,1), track: track("LH_INT3"), place: swing_city, start_time: '19:00', hashtag: "LIMBO", valid_until: Date.new(2016,7,31)
course "LIMBO_3", name: "Limbo 3 - Intermedios 2 - Viernes Vera", weekday: 5, valid_since: Date.new(2015,7,1), track: track("LH_AVAN"), place: vera, start_time: '19:00', hashtag: "LIMBO", valid_until: Date.new(2015,8,2)

course "BALBOA_SHAG_JUE", name: "Balboa/Shag/20's - Jueves", weekday: 4, valid_since: Date.new(2016,8,1), track: track("BALBOA_SHAG"), place: swing_city, start_time: '19:00'

course "ESTIRA_LUN", name: "Estiramiento - Lunes", weekday: 1, valid_since: Date.new(2016,8,1), track: track("ESTIRAMIENTO"), place: swing_city, start_time: '21:00'
course "ESTIRA_LUN2", name: "Estiramiento - Lunes mañana", weekday: 1, valid_since: Date.new(2017,3,1), track: track("ESTIRAMIENTO"), place: swing_city, start_time: '11:00'
course "ESTIRA_MAR", name: "Estiramiento - Martes", weekday: 2, valid_since: Date.new(2016,4,1), track: track("ESTIRAMIENTO"), place: swing_city, start_time: '18:00', valid_until: Date.new(2015,5,31)
course "ESTIRA_JUE", name: "Estiramiento - Jueves", weekday: 4, valid_since: Date.new(2016,4,1), track: track("ESTIRAMIENTO"), place: swing_city, start_time: '18:00'
course "ESTIRA_SAB", name: "Estiramiento - Sábados", weekday: 6, valid_since: Date.new(2016,4,1), valid_until: Date.new(2016,12,31), track: track("ESTIRAMIENTO"), place: swing_city, start_time: '16:00'
course "ESTIRA_SAB2", name: "Estiramiento - Sábados", weekday: 6, valid_since: Date.new(2017,1,1), track: track("ESTIRAMIENTO"), place: swing_city, start_time: '19:00'


course "PREP_SAB", name: "Preparación Física - Sábados", weekday: 6, valid_since: Date.new(2016,4,1), track: track("PREP_FISICA"), place: swing_city, start_time: '15:00', valid_until: Date.new(2016,7,21)

course "SWING_KIDS_MAR", name: "Swing Kids - Martes", weekday: 2, valid_since: Date.new(2016,4,1), track: track("SWING_KIDS"), place: swing_city, start_time: '18:00', valid_until: Date.new(2015,5,31)
course "SWING_KIDS_JUE", name: "Swing Kids - Jueves", weekday: 4, valid_since: Date.new(2016,4,1), track: track("SWING_KIDS"), place: swing_city, start_time: '18:00', valid_until: Date.new(2015,5,31)

course "TAP_KIDS_MAR", name: "Tap Kids - Lunes", weekday: 1, valid_since: Date.new(2016,4,1), track: track("TAP_KIDS"), place: swing_city, start_time: '18:00'
course "TAP_KIDS_MIE", name: "Tap Kids - Miércoles", weekday: 3, valid_since: Date.new(2016,4,1), track: track("TAP_KIDS"), place: swing_city, start_time: '18:00'
course "TAP_KIDS_JUE", name: "Tap Kids - Jueves", weekday: 4, valid_since: Date.new(2016,4,1), valid_until: Date.new(2016,4,2), track: track("TAP_KIDS"), place: swing_city, start_time: '18:00'

course "SWING_SENIOR_LUN", name: "Swing Senior - Lunes", weekday: 1, valid_since: Date.new(2016,7,1), track: track("SWING_SENIOR"), place: swing_city, start_time: '18:00'
course "SWING_SENIOR_MIE", name: "Swing Senior - Miércoles", weekday: 3, valid_since: Date.new(2016,7,1), track: track("SWING_SENIOR"), place: swing_city, start_time: '18:00'
course "SWING_SENIOR_SAB", name: "Swing Senior - Sábados", weekday: 6, valid_since: Date.new(2017,1,1), track: track("SWING_SENIOR"), place: swing_city, start_time: '16:00'


payment_plan "LIBRE", description: "1 Mes. Libre $1300", price: 1300, weekly_classes: 40
payment_plan "3_MESES", description: "3 Meses 1 x Semana $950", price: 950, weekly_classes: 1
payment_plan "3_X_SEMANA", description: "Mensual 3 x Semana $900", price: 900, weekly_classes: 3
payment_plan "2_X_SEMANA", description: "Mensual 2 x Semana $700", price: 700, weekly_classes: 2
payment_plan "1_X_SEMANA_3", description: "Mensual 1 x Semana (3 c) $330", price: 330, weekly_classes: 1
payment_plan "1_X_SEMANA_4", description: "Mensual 1 x Semana (4 c) $420", price: 420, weekly_classes: 1
payment_plan "1_X_SEMANA_5", description: "Mensual 1 x Semana (5 c) $520", price: 520, weekly_classes: 1
payment_plan PaymentPlan::SINGLE_CLASS, description: "Clase suelta $130", price: 130, weekly_classes: 1
payment_plan PaymentPlan::OTHER, description: "Otro (monto a continuación)", price: 0, weekly_classes: 1
