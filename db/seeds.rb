# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def track(code, attributes = {})
  Track.find_or_create_by(code: code).tap do |track|
    attributes.each do |key, value|
      track.send "#{key}=", value
    end
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

def fixed_fee(code, attributes)
  FixedFee.find_or_create_by(code: code).tap do |fee|
    attributes.each do |key, value|
      fee.send "#{key}=", value
    end
    fee.save!
  end
end

teacher 'Mariel', cashier: true, priority: 1
teacher 'Manuel', cashier: true, priority: 1
teacher 'Juani', priority: 1, deleted_at: Date.new(2022,3,1)
teacher 'Candela', priority: 0, deleted_at: Date.new(2016,2,1)
teacher 'Mariano', priority: 2
teacher 'Celeste', priority: 2
teacher 'Nanchi', priority: 2, deleted_at: Date.new(2022,3,1)
teacher 'Sol', priority: 2, deleted_at: Date.new(2022,3,1)
teacher 'Majo', priority: 0
teacher 'Brian', cashier: true, priority: 3

teacher 'Otro', priority: 10

teacher 'Martina', cashier: true, priority: 0, deleted_at: Date.new(2019,3,1)
teacher 'Blake', cashier: true, priority: 0, deleted_at: Date.new(2019,3,1)
teacher 'Belu', cashier: true, priority: 0, deleted_at: Date.new(2019,3,1)
teacher 'Lala', cashier: true, priority: 0, deleted_at: Date.new(2022,3,1)
teacher 'Mar Tin', cashier: true, priority: 0, deleted_at: Date.new(2022,3,1)
teacher 'Vale K', cashier: true, priority: 0
teacher 'Ailin', cashier: true, priority: 3

teacher 'Victoria', cashier: true, priority: 2
teacher 'Farru', priority: 3, deleted_at: Date.new(2022,3,1)
teacher 'Soledad', priority: 3, deleted_at: Date.new(2018,11,30)
teacher 'Edu', priority: 0, deleted_at: Date.new(2017,7,24)
teacher 'Eliana', priority: 3
teacher 'Agustín', priority: 3
teacher 'ManuH', priority: 3
teacher 'Carla', priority: 3, deleted_at: Date.new(2022,3,1)
teacher 'Ornella', cashier: true, priority: 3
teacher 'Guido', priority: 3
teacher 'Agus Giralt', priority: 3
teacher 'Gaby', priority: 3
teacher 'Santi', cashier: true, priority: 3, deleted_at: Date.new(2022,3,1)

teacher 'Santi A', priority: 3
teacher 'Euge D', priority: 3
teacher 'Aye R', priority: 3

teacher 'Emiliano', priority: 4, deleted_at: Date.new(2022,3,1)
teacher 'Griselda', priority: 4, deleted_at: Date.new(2022,3,1)
teacher 'Lucas', priority: 4, deleted_at: Date.new(2018,11,30)
teacher 'Maxim', priority: 4, deleted_at: Date.new(2018,11,30)
teacher 'Rulock', priority: 4, deleted_at: Date.new(2022,3,1)
teacher 'Zai', priority: 4, deleted_at: Date.new(2019,3,1)
teacher 'Freddy', priority: 4, deleted_at: Date.new(2019,3,1)

teacher 'Javi', cashier: true, priority: 4

caballito = place Place::CABALLITO, address: "Rivadavia 4127", link: "https://goo.gl/maps/phcr8"
colmegna = place "Colmegna Spa Urbano", address: "Sarmiento 839", link: "http://goo.gl/sTPxUh"
la_huella = place "La Huella", address: "Bulnes 892", link: "http://goo.gl/kT1ElX"
vera = place "Oliverio Girondo Espacio Cultural", address: "Vera 574", link: "http://goo.gl/VgcPe6"
sendas = place "Sendas del Sol", address: "Lambaré 990", link: "http://goo.gl/BAZsox"
ibera = place "Pororoca", address: "Iberá 2385", link: "http://goo.gl/Rosg56"
chez_manuel = place "Chez Manuel", address: "Paraná y Córdoba", link: "#"
danzas = place "Academia Integral de Danzas", address: "Av. Scalabrini Ortiz 885", link: "http://goo.gl/TyVh85"
swing_city = place "Swing City", address: "Av. Scalabrini Ortiz 103", link: "https://goo.gl/maps/SjATQh9YyVP2"

track("AERIALS_INT1", name: "Aerials - Intermedios 1", color: "#ce0a24", course_kind: "swing")
track("AERIALS_PRIN", name: "Aerials - Principiantes", color: "#ce0a24", course_kind: "swing")

track("AJ_PRIN", name: "Authentic Jazz - Principiantes", color: "#71a9a4", course_kind: "swing")
track("AJ_PRIN_IMPRO", name: "Authentic Jazz - Principiantes - Impro", color: "#71a9a4", course_kind: "swing")
track("AJ_PRIN_MUSIC_Y_COREO", name: "Authentic Jazz - Principiantes - Musicalidad y Coreo", color: "#71a9a4", course_kind: "swing")
track("AJ_PRIN_PLUS", name: "Authentic Jazz - Principiantes+", color: "#71a9a4", course_kind: "swing")
track("AJ_INT1", name: "Authentic Jazz - Intermedios 1", color: "#71a9a4", course_kind: "swing")
track("AJ_INT1_RUTINAS", name: "Authentic Jazz - Intermedios - Rutinas Clásicas", color: "#71a9a4", course_kind: "swing")
track("AJ_INT_MUSIC_Y_COREO", name: "Authentic Jazz - Intermedios - Musicalidad y Coreo", color: "#71a9a4", course_kind: "swing")
track("AJ_INT_IMPRO", name: "Authentic Jazz - Intermedios - Impro", color: "#71a9a4", course_kind: "swing")
track("AJ_AVAN", name: "Authentic Jazz - Avanzados", color: "#71a9a4", course_kind: "swing")
track("AJ_AVAN_MUSIC_Y_COREO", name: "Authentic Jazz - Avanzados - Musicalidad y Coreo", color: "#71a9a4", course_kind: "swing")
track("AJ_AVAN_IMPRO", name: "Authentic Jazz - Avanzados - Impro", color: "#71a9a4", course_kind: "swing")
track("AJ_AVAN_PLUS", name: "Authentic Jazz - Avanzados+", color: "#71a9a4", course_kind: "swing")


track("AJ_TP_PRIN", name: "Authentic Jazz & Tap - Principiantes", color: "#71a9a4", course_kind: "swing")
track("AJ_TP_INT", name: "Authentic Jazz & Tap - Intermedios", color: "#71a9a4", course_kind: "swing")
track("AJ_TP_AVAN", name: "Authentic Jazz & Tap - Avanzados", color: "#71a9a4", course_kind: "swing")

track("SHAG", name: "Shag", color: "#005f42", course_kind: "swing")
track("SHAG_PRIN", name: "Shag - Principiantes", color: "#005f42", course_kind: "swing")
track("SHAG_INT1", name: "Shag - Intermedios 1", color: "#005f42", course_kind: "swing")
track("SHAG_TODO_NIV", name: "Shag - Todo Nivel", color: "#005f42", course_kind: "swing")

track("BALBOA_TODO_NIV", name: "Balboa - Todo nivel", color: "#248549", course_kind: "swing")
track("BALBOA_PRIN", name: "Balboa - Principiantes", color: "#248549", course_kind: "swing")
track("BALBOA_INT1", name: "Balboa - Intermedios 1", color: "#248549", course_kind: "swing")
track("BALBOA_SHAG", name: "Balboa/Shag/20's", color: "#248549", course_kind: "swing")

track("BLUES_INT1", name: "Blues - Intermedios 1", color: "#4873b1", course_kind: "swing")
track("BLUES_PRIN", name: "Blues - Principiantes", color: "#4873b1", course_kind: "swing")

track("ESTIRAMIENTO", name: "Estiramiento", color: "#5b9bd5", course_kind: "swing")

track("INTRO_BAILE", name: "Intro al Baile", color: "#92d050", course_kind: "swing")

track("LH_AVAN", name: "Lindy Hop - Avanzados", color: "#ec3b62", course_kind: "swing")
track("LH_AVAN2", name: "Lindy Hop - Avanzados 2", color: "#ec3b62", course_kind: "swing")
track("LH_COREO", name: "Lindy Hop Coreo", color: "#ad0855", course_kind: "swing")
track("LH_INT1", name: "Lindy Hop - Intermedios 1", color: "#ec3b62", course_kind: "swing")
track("LH_INT1_PLUS", name: "Lindy Hop - Intermedios 1+", color: "#af3a3a", course_kind: "swing")
track("LH_INT2", name: "Lindy Hop - Intermedios 2", color: "#ec3b62", course_kind: "swing")
track("LH_INT2_PLUS", name: "Lindy Hop - Intermedios 2+", color: "#af3a3a", course_kind: "swing")
track("LH_INT3", name: "Lindy Hop - Intermedios 3", color: "#ec3b62", course_kind: "swing")
track("LH_INT3_PLUS", name: "Lindy Hop - Intermedios 3+", color: "#af3a3a", course_kind: "swing")
track("LH_PRIN", name: "Lindy Hop - Principiantes", color: "#ec3b62", course_kind: "swing")
track("LH_PRIN_PLUS", name: "Lindy Hop - Principiantes+", color: "#af3a3a", course_kind: "swing")

track("PREP_FISICA", name: "Preparación Física", color: "#5b9bd5", course_kind: "swing")
track("SWING_KIDS", name: "Swing Kids", color: "#795fb6", course_kind: "swing")
track("SWING_SENIOR", name: "Swing Senior", color: "#828282", course_kind: "swing")

track("TAP_KIDS", name: "Tap Kids", color: "#795fb6", course_kind: "swing")
track("TP_AVAN", name: "Tap - Avanzados", color: "#fab258", course_kind: "swing")
track("TP_INT1", name: "Tap - Intermedios 1", color: "#fab258", course_kind: "swing")
track("TP_INT2", name: "Tap - Intermedios 2", color: "#fab258", course_kind: "swing")
track("TP_PRIN", name: "Tap - Principiantes", color: "#fab258", course_kind: "swing")
track("TP_PRIN_IMPRO", name: "Tap - Impro", color: "#fab258", course_kind: "swing")

track("TEO_MUSICAL", name: "Teoría Musical", color: "#000000", course_kind: "swing")

track("BOOGIE_PRIN", name: "Boogie Boogie - Principiantes", color: "#fcae00", course_kind: "swing")
track("BOOGIE_INT1", name: "Boogie Boogie - Intermedios 1", color: "#fcae00", course_kind: "swing")
track("BOOGIE_TODO_NIV", name: "Boogie Boogie - Todo nivel", color: "#fcae00", course_kind: "swing")

track("LOCKING", name: "Locking", color: "#4fadeb", course_kind: "roots")
track("HOUSE", name: "House", color: "#88219d", course_kind: "roots")
track("WAACKING", name: "Waacking", color: "#d832a8", course_kind: "roots")
track("POPPING", name: "Popping", color: "#f6c242", course_kind: "roots")
track("BREAKING", name: "Breaking", color: "#e93323", course_kind: "roots")
track("HIP_HOP_PRIN", name: "Hip Hop - Principiantes", color: "#2e6ab3", course_kind: "roots")
track("HIP_HOP_INT", name: "Hip Hop - Intermedios", color: "#2e6ab3", course_kind: "roots")
track("AFRO_URBANO", name: "Afro Urbano", color: "#827f06", course_kind: "roots")

track("DANZA_AFRO", name: "Danza Afro", color: "#4ead5b", course_kind: "afro")

track("FUNKY", name: "Funky Styles", color: "#4fadeb", course_kind: "roots")

course "AJ_PRIN_LUN", name: "Authentic Jazz - Principiantes - Lunes", weekday: 1, valid_since: Date.new(2016,4,1), track: track("AJ_PRIN"), place: swing_city, start_time: '19:00'
course "AJ_PRIN_LUN2", name: "Authentic Jazz - Principiantes - Lunes mañana", weekday: 1, valid_since: Date.new(2017,3,1), track: track("AJ_PRIN"), place: swing_city, start_time: '10:00', valid_until: Date.new(2018,12,31)
course "AJ_PRIN_LUN3", name: "Authentic Jazz - Principiantes - Lunes mañana", weekday: 1, valid_since: Date.new(2019,3,1), track: track("AJ_PRIN"), place: swing_city, start_time: '11:00', valid_until: nil
course "AJ_PRIN_MIE", name: "Authentic Jazz - Principiantes - Miércoles", weekday: 3, track: track("AJ_PRIN"), place: swing_city, start_time: '19:00'
course "AJ_PRIN_SAB", name: "Authentic Jazz - Principiantes - Sábados", weekday: 6, track: track("AJ_PRIN"), place: swing_city, start_time: '17:00', valid_since: Date.new(2017,8,1), valid_until: Date.new(2017,12,31)
course "AJ_PRIN_SAB2", name: "Authentic Jazz - Principiantes - Sábados", weekday: 6, track: track("AJ_PRIN"), place: swing_city, start_time: '18:00', valid_since: Date.new(2018,1,1), valid_until: nil

course "AJ_INT1_LUN", name: "Authentic Jazz - Intermedios 1 - Lunes mañana", weekday: 1, track: track("AJ_INT1"), place: swing_city, valid_since: Date.new(2017,6,1), start_time: '11:00', valid_until: Date.new(2018,12,31)
course "AJ_INT1_LUN2", name: "Authentic Jazz - Intermedios 1 - Lunes", weekday: 1, track: track("AJ_INT1"), place: swing_city, valid_since: Date.new(2018,1,1), start_time: '20:00'
course "AJ_INT1_MIE", name: "Authentic Jazz - Intermedios 1 - Miércoles", weekday: 3, track: track("AJ_INT1"), place: swing_city, valid_since: Date.new(2017,1,1), start_time: '20:00'
course "AJ_INT1_JUE", name: "Authentic Jazz - Intermedios 1 - Jueves", weekday: 4, track: track("AJ_INT1"), place: swing_city, valid_since: Date.new(2017,4,19), valid_until: Date.new(2017,12,31), start_time: '19:00'
course "AJ_INT1_SAB", name: "Authentic Jazz - Intermedios 1 - Sábados", weekday: 6, valid_since: Date.new(2018,1,1), track: track("AJ_INT1"), place: swing_city, start_time: '17:00', valid_until: Date.new(2018,12,31)

course "AJ_AVAN_MAR", name: "Authentic Jazz - Avanzados - Martes", weekday: 2, track: track("AJ_AVAN"), place: swing_city, valid_since: Date.new(2017,1,1), start_time: '19:00'
course "AJ_AVAN_MIE", name: "Authentic Jazz - Avanzados - Miércoles", weekday: 3, track: track("AJ_AVAN"), place: swing_city, start_time: '20:00', valid_until: Date.new(2016,12,31)
course "AJ_AVAN_SAB", name: "Authentic Jazz - Avanzados - Sábados", weekday: 6, valid_since: Date.new(2016,1,1), track: track("AJ_AVAN"), place: swing_city, start_time: '17:00', valid_until: Date.new(2017,12,31)
course "AJ_AVAN_SAB2", name: "Authentic Jazz - Avanzados - Sábados", weekday: 6, valid_since: Date.new(2018,1,1), track: track("AJ_AVAN"), place: swing_city, start_time: '20:00', valid_until: nil

course "LH_INT1_LUN", name: "Lindy Hop - Intermedios 1 - Lunes", weekday: 1, track: track("LH_INT1"), place: swing_city, start_time: '20:00', valid_until: Date.new(2018,6,30)
course "LH_INT1_LUN2", name: "Lindy Hop - Intermedios 1 - Lunes mañana", weekday: 1, valid_since: Date.new(2017,6,1), track: track("LH_INT1"), place: swing_city, start_time: '10:00', valid_until: Date.new(2018,12,31)
course "LH_INT1_MAR", name: "Lindy Hop - Intermedios 1 - Martes", weekday: 2, track: track("LH_INT1"), place: swing_city, start_time: '19:00'
course "LH_INT1_MIE", name: "Lindy Hop - Intermedios 1 - Miércoles", weekday: 3, track: track("LH_INT1"), place: swing_city, start_time: '19:00'
course "LH_INT1_JUE", name: "Lindy Hop - Intermedios 1 - Jueves", weekday: 4, track: track("LH_INT1"), place: swing_city, start_time: '19:00'
# course "LH_INT1_VIE", name: "Lindy Hop - Intermedios 1 - Viernes Malcom", weekday: 5, valid_until: Date.new(2015,5,31), track: track("LH_INT1"), start_time: '8:00'
course "LH_INT1_VIE_PARANA", name: "Lindy Hop - Intermedios 1 - Viernes Paraná y Córdoba", weekday: 5, track: track("LH_INT1"), place: chez_manuel, start_time: '20:30', valid_until: Date.new(2015,8,2)
course "LH_INT1_VIE_IBERA", name: "Lindy Hop - Intermedios 1 - Viernes Iberá", weekday: 5, track: track("LH_INT1"), place: ibera, start_time: '20:00', valid_until: Date.new(2016, 3, 31)
course "LH_INT1_VIE_SC", name: "Lindy Hop - Intermedios 1 - Viernes", weekday: 5, valid_since: Date.new(2016,1,1), track: track("LH_INT1"), place: swing_city, start_time: '20:00'
course "LH_PRIN_VIE2", name: "Lindy Hop - Principiantes - Viernes", weekday: 5, valid_since: Date.new(2016,1,1), track: track("LH_INT1"), place: swing_city, start_time: '20:00'
course "LH_INT1_SAB", name: "Lindy Hop - Intermedios 1 - Sábados", weekday: 6, valid_since: Date.new(2015,6,1), track: track("LH_INT1"), place: swing_city, start_time: '17:00'

course "LH_INT1_PLUS_LUN", name: "Lindy Hop - Intermedios 1+ - Lunes", weekday: 1, track: track("LH_INT1_PLUS"), place: swing_city, start_time: '21:00', valid_since: Date.new(2018,3,1), valid_until: nil
course "LH_INT1_PLUS_MIE", name: "Lindy Hop - Intermedios 1+ - Miércoles", weekday: 3, track: track("LH_INT1_PLUS"), place: swing_city, start_time: '19:00', valid_since: Date.new(2018,3,1), valid_until: nil

course "LH_INT2_LUN", name: "Lindy Hop - Intermedios 2 - Lunes", weekday: 1, track: track("LH_INT2"), place: swing_city, start_time: '19:00'
course "LH_INT2_MIE", name: "Lindy Hop - Intermedios 2 - Miércoles", weekday: 3, track: track("LH_INT2"), place: swing_city, start_time: '21:00', valid_since: Date.new(2017,11,1), valid_until: Date.new(2018,12,31)
course "LH_INT2_JUE", name: "Lindy Hop - Intermedios 2 - Jueves", weekday: 4, track: track("LH_INT2"), place: swing_city, start_time: '20:00'
course "LH_INT2_SAB", name: "Lindy Hop - Intermedios 2 - Sábados", weekday: 6, valid_since: Date.new(2015,6,1), valid_until: Date.new(2017,12,31), track: track("LH_INT2"), place: swing_city, start_time: '18:00'
course "LH_INT2_SAB2", name: "Lindy Hop - Intermedios 2 - Sábados", weekday: 6, valid_since: Date.new(2018,1,1), valid_until: nil, track: track("LH_INT2"), place: swing_city, start_time: '20:00'

course "LH_INT2_PLUS_SAB", name: "Lindy Hop - Intermedios 2+ - Sábados", weekday: 6, track: track("LH_INT2_PLUS"), place: swing_city, start_time: '17:00', valid_since: Date.new(2018,3,1), valid_until: Date.new(2018,6,30)

course "LH_INT3_MAR", name: "Lindy Hop - Intermedios 3 - Martes", weekday: 2, valid_since: Date.new(2016,1,1), track: track("LH_INT3"), place: swing_city, start_time: '20:00'
course "LH_INT3_SAB", name: "Lindy Hop - Intermedios 3 - Sábados", weekday: 6, valid_since: Date.new(2016,10,7), valid_until: Date.new(2017,12,31), track: track("LH_INT3"), place: swing_city, start_time: '16:00'
course "LH_INT3_SAB2", name: "Lindy Hop - Intermedios 3 - Sábados", weekday: 6, valid_since: Date.new(2018,1,1), valid_until: nil, track: track("LH_INT3"), place: swing_city, start_time: '19:00'

course "LH_INT3_PLUS_SAB", name: "Lindy Hop - Intermedios 3+ - Sábados", weekday: 6, track: track("LH_INT3_PLUS"), place: swing_city, start_time: '18:00', valid_since: Date.new(2018,3,1), valid_until: Date.new(2018,12,31)

course "LH_PRIN_LUN", name: "Lindy Hop - Principiantes - Lunes", weekday: 1, track: track("LH_PRIN"), place: swing_city, start_time: '19:00'
course "LH_PRIN_LUN2", name: "Lindy Hop - Principiantes - Lunes mañana", weekday: 1, track: track("LH_PRIN"), place: swing_city, start_time: '11:00', valid_since: Date.new(2017,3,1), valid_until: Date.new(2018,12,31)
course "LH_PRIN_LUN3", name: "Lindy Hop - Principiantes - Lunes mañana", weekday: 1, track: track("LH_PRIN"), place: swing_city, start_time: '12:00', valid_since: Date.new(2019,3,1), valid_until: nil
course "LH_PRIN_MAR2", name: "Lindy Hop - Principiantes - Martes", weekday: 2, track: track("LH_PRIN"), place: swing_city, start_time: '20:00'
course "LH_PRIN_MIE2", name: "Lindy Hop - Principiantes - Miércoles", weekday: 3, track: track("LH_PRIN"), place: swing_city, start_time: '20:00'
course "LH_PRIN_MIE", name: "Lindy Hop - Principiantes - Miércoles colmegna", weekday: 3, valid_until: Date.new(2015,5,31), track: track("LH_PRIN"), place: swing_city, start_time: '8:00'
course "LH_PRIN_JUE", name: "Lindy Hop - Principiantes - Jueves", weekday: 4, track: track("LH_PRIN"), place: swing_city, start_time: '20:00'
course "LH_PRIN_VIE", name: "Lindy Hop - Principiantes - Viernes Iberá", weekday: 5, track: track("LH_PRIN"), place: ibera, start_time: '19:00', valid_until: Date.new(2016, 3, 31)
course "LH_PRIN_VIE2", name: "Lindy Hop - Principiantes - Viernes", weekday: 5, valid_since: Date.new(2016,1,1), track: track("LH_PRIN"), place: swing_city, start_time: '19:00'
course "LH_PRIN_SAB", name: "Lindy Hop - Principiantes - Sábados", weekday: 6, track: track("LH_PRIN"), place: swing_city, start_time: '18:00'

course "LH_PRIN_PLUS_MIE", name: "Lindy Hop - Principiantes+ - Miércoles", weekday: 3, track: track("LH_PRIN_PLUS"), place: swing_city, start_time: '20:00', valid_since: Date.new(2018,3,1), valid_until: nil
course "LH_PRIN_PLUS_VIE", name: "Lindy Hop - Principiantes+ - Viernes", weekday: 5, track: track("LH_PRIN_PLUS"), place: swing_city, start_time: '20:00', valid_since: Date.new(2018,3,1), valid_until: Date.new(2018,6,30)

course "LH_AVAN_LUN", name: "Lindy Hop - Avanzados - Lunes", weekday: 1, track: track("LH_AVAN"), place: swing_city, start_time: '20:00', valid_until: Date.new(2017,12,31)
course "LH_AVAN_SAB", name: "Lindy Hop - Avanzados - Sábados", weekday: 6, valid_since: Date.new(2016,1,1), valid_until: Date.new(2016, 10, 2), track: track("LH_AVAN"), place: swing_city, start_time: '16:00'
course "LH_AVAN_SAB2", name: "Lindy Hop - Avanzados - Sábados", weekday: 6, valid_since: Date.new(2018,1,1), valid_until: nil, track: track("LH_AVAN"), place: swing_city, start_time: '19:00'

course "LH_AVAN2_MAR", name: "Lindy Hop - Avanzados 2 - Martes", weekday: 2, valid_since: Date.new(2016,1,1), track: track("LH_AVAN2"), place: swing_city, start_time: '19:00', valid_until: Date.new(2016,8,31)

course "TP_PRIN_LUN", name: "Tap - Principiantes - Lunes", weekday: 1, valid_since: Date.new(2016,4,1), track: track("TP_PRIN"), place: swing_city, start_time: '20:00'
course "TP_PRIN_LUN2", name: "Tap - Principiantes - Lunes mañana", weekday: 1, valid_since: Date.new(2017,3,1), track: track("TP_PRIN"), place: swing_city, start_time: '10:00', valid_until: Date.new(2018,12,31)
course "TP_PRIN_LUN3", name: "Tap - Principiantes - Lunes mañana", weekday: 1, valid_since: Date.new(2019,3,1), track: track("TP_PRIN"), place: swing_city, start_time: '11:00', valid_until: nil
course "TP_PRIN_MAR", name: "Tap - Principiantes - Martes La huella", weekday: 2, valid_until: Date.new(2015,5,31), track: track("TP_PRIN"), place: la_huella, start_time: '8:00'
course "TP_PRIN_MAR2", name: "Tap - Principiantes - Martes", weekday: 2, valid_since: Date.new(2016,1,1), valid_until: Date.new(2016,12,31), track: track("TP_PRIN"), place: swing_city, start_time: '19:00'
course "TP_PRIN_MAR3", name: "Tap - Principiantes - Martes", weekday: 2, valid_since: Date.new(2017,1,1), track: track("TP_PRIN"), place: swing_city, start_time: '20:00'
# course "TP_PRIN_MIE", name: "Tap - Principiantes - Miércoles Medrano", weekday: 3, valid_until: Date.new(2015,5,31), track: track("TP_PRIN"), start_time: '8:00'
course "TP_PRIN_MIE2", name: "Tap - Principiantes - Miércoles mañana", weekday: 3, track: track("TP_PRIN"), place: swing_city, start_time: '10:00', valid_since: Date.new(2018,3,1), valid_until: Date.new(2018,12,31)
course "TP_PRIN_VIE", name: "Tap - Principiantes - Viernes", weekday: 5, valid_since: Date.new(2015,6,1), track: track("TP_PRIN"), place: swing_city, start_time: '19:00'

course "TP_INT1_LUN", name: "Tap - Intermedios 1 - Lunes mañana", weekday: 1, track: track("TP_INT1"), place: swing_city, valid_since: Date.new(2017,6,1), valid_until: Date.new(2017,12,31), start_time: '11:00'
course "TP_INT1_LUN3", name: "Tap - Intermedios 1 - Lunes mañana", weekday: 1, track: track("TP_INT1"), place: swing_city, valid_since: Date.new(2018,2,1), start_time: '12:00', valid_until: Date.new(2018,12,31)
course "TP_INT1_LUN2", name: "Tap - Intermedios 1 - Lunes", weekday: 1, track: track("TP_INT1"), place: swing_city, valid_since: Date.new(2018,1,1), valid_until: Date.new(2018,1,31), start_time: '21:00'
course "TP_INT1_LUN4", name: "Tap - Intermedios 1 - Lunes", weekday: 1, track: track("TP_INT1"), place: swing_city, valid_since: Date.new(2018,2,1), valid_until: nil, start_time: '18:00'
course "TP_INT1_LUN5", name: "Tap - Intermedios 1 - Lunes mañana", weekday: 1, track: track("TP_INT1"), place: swing_city, valid_since: Date.new(2019,3,1), start_time: '12:00', valid_until: nil
course "TP_INT1_MAR", name: "Tap - Intermedios 1 - Martes", weekday: 2, track: track("TP_INT1"), place: swing_city, valid_until: Date.new(2016,12,31), start_time: '18:00'
course "TP_INT1_MAR2", name: "Tap - Intermedios 1 - Martes", weekday: 2, valid_since: Date.new(2017,1,1), track: track("TP_INT1"), place: swing_city, start_time: '19:00'
course "TP_INT1_MIE", name: "Tap - Intermedios 1 - Miércoles", weekday: 3, track: track("TP_INT1"), place: swing_city, valid_since: Date.new(2017,8,23), valid_until: Date.new(2017,12,31), start_time: '11:00'
course "TP_INT1_MIE2", name: "Tap - Intermedios 1 - Miércoles mañana", weekday: 3, track: track("TP_INT1"), place: swing_city, start_time: '12:00', valid_since: Date.new(2018,3,1), valid_until: Date.new(2018,12,31)
course "TP_INT1_VIE", name: "Tap - Intermedios 1 - Viernes", weekday: 5, valid_since: Date.new(2015,6,1), track: track("TP_INT1"), place: swing_city, start_time: '20:00'

course "TP_INT2_LUN", name: "Tap - Intermedios 2 - Lunes mañana", weekday: 1, track: track("TP_INT2"), place: swing_city, valid_since: Date.new(2018,1,1), start_time: '11:00', valid_until: Date.new(2018,12,31)
course "TP_INT2_LUN2", name: "Tap - Intermedios 2 - Lunes", weekday: 1, track: track("TP_INT2"), place: swing_city, valid_since: Date.new(2018,2,1), valid_until: nil, start_time: '21:00'
course "TP_INT2_MAR", name: "Tap - Intermedios 2 - Martes", weekday: 2, track: track("TP_INT2"), place: swing_city, valid_until: Date.new(2017,12,31), start_time: '18:00'
course "TP_INT2_MIE", name: "Tap - Intermedios 2 - Miércoles", weekday: 3, track: track("TP_INT2"), place: swing_city, valid_since: Date.new(2018,1,1), start_time: '11:00', valid_until: Date.new(2018,12,31)

course "TP_AVAN_MAR", name: "Tap - Avanzados - Martes", weekday: 2, track: track("TP_AVAN"), place: swing_city, valid_since: Date.new(2018,1,1), valid_until: Date.new(2018,3,31), start_time: '18:00'

course "LIMBO_1", name: "Limbo 1 - Principiantes - Miércoles", weekday: 3, valid_since: Date.new(2015,7,1), track: track("LH_INT1"), place: swing_city, start_time: '20:00', hashtag: "LIMBO", valid_until: Date.new(2018,2,28)
course "LIMBO_2", name: "Limbo 2 - Intermedios 1 - Miércoles", weekday: 3, valid_since: Date.new(2015,7,1), track: track("LH_INT2"), place: swing_city, start_time: '19:00', hashtag: "LIMBO", valid_until: Date.new(2018,2,28)
course "LIMBO_3_JUE", name: "Limbo 3 - Intermedios 2 - Jueves", weekday: 4, valid_since: Date.new(2015,7,1), track: track("LH_INT3"), place: swing_city, start_time: '19:00', hashtag: "LIMBO", valid_until: Date.new(2016,7,31)
course "LIMBO_3", name: "Limbo 3 - Intermedios 2 - Viernes Vera", weekday: 5, valid_since: Date.new(2015,7,1), track: track("LH_AVAN"), place: vera, start_time: '19:00', hashtag: "LIMBO", valid_until: Date.new(2015,8,2)

course "BALBOA_SHAG_JUE", name: "Balboa/Shag/20's - Jueves", weekday: 4, valid_since: Date.new(2016,8,1), track: track("BALBOA_SHAG"), place: swing_city, start_time: '19:00', valid_until: Date.new(2017,4,16)
course "SHAG_SAB", name: "Shag - Sábados", weekday: 6, valid_since: Date.new(2018,6,30), track: track("SHAG"), place: swing_city, start_time: '15:00', valid_until: Date.new(2018,12,31)

course "SHAG_PRIN_SAB", name: "Shag - Principiantes - Sábados", weekday: 6, valid_since: Date.new(2019,1,1), track: track("SHAG_PRIN"), place: swing_city, start_time: '17:00', valid_until: nil
course "SHAG_INT1_SAB", name: "Shag - Intermedios 1 - Sábados", weekday: 6, valid_since: Date.new(2019,1,1), track: track("SHAG_INT1"), place: swing_city, start_time: '18:00', valid_until: nil

course "ESTIRA_LUN", name: "Estiramiento - Lunes", weekday: 1, valid_since: Date.new(2016,8,1), track: track("ESTIRAMIENTO"), place: swing_city, valid_until: Date.new(2017,12,31), start_time: '21:00'
course "ESTIRA_LUN2", name: "Estiramiento - Lunes mañana", weekday: 1, valid_since: Date.new(2017,3,1), track: track("ESTIRAMIENTO"), place: swing_city, start_time: '12:00', valid_until: Date.new(2018,12,31)
course "ESTIRA_MAR", name: "Estiramiento - Martes", weekday: 2, valid_since: Date.new(2016,4,1), track: track("ESTIRAMIENTO"), place: swing_city, start_time: '18:00', valid_until: Date.new(2015,5,31)
course "ESTIRA_MAR2", name: "Estiramiento - Martes", weekday: 2, valid_since: Date.new(2018,1,1), track: track("ESTIRAMIENTO"), place: swing_city, start_time: '21:00', valid_until: nil
course "ESTIRA_JUE", name: "Estiramiento - Jueves", weekday: 4, valid_since: Date.new(2016,4,1), track: track("ESTIRAMIENTO"), place: swing_city, start_time: '21:00'
course "ESTIRA_SAB", name: "Estiramiento - Sábados", weekday: 6, valid_since: Date.new(2016,4,1), valid_until: Date.new(2016,12,31), track: track("ESTIRAMIENTO"), place: swing_city, start_time: '16:00'
course "ESTIRA_SAB2", name: "Estiramiento - Sábados", weekday: 6, valid_since: Date.new(2017,1,1), valid_until: Date.new(2017,12,31), track: track("ESTIRAMIENTO"), place: swing_city, start_time: '19:00'
course "ESTIRA_SAB3", name: "Estiramiento - Sábados", weekday: 6, valid_since: Date.new(2018,1,1), valid_until: nil, track: track("ESTIRAMIENTO"), place: swing_city, start_time: '20:00'

course "PREP_SAB", name: "Preparación Física - Sábados", weekday: 6, valid_since: Date.new(2016,4,1), track: track("PREP_FISICA"), place: swing_city, start_time: '15:00', valid_until: Date.new(2016,7,21)

course "SWING_KIDS_MAR", name: "Swing Kids - Martes", weekday: 2, valid_since: Date.new(2016,4,1), track: track("SWING_KIDS"), place: swing_city, start_time: '18:00', valid_until: Date.new(2015,5,31)
course "SWING_KIDS_JUE", name: "Swing Kids - Jueves", weekday: 4, valid_since: Date.new(2016,4,1), track: track("SWING_KIDS"), place: swing_city, start_time: '18:00', valid_until: Date.new(2015,5,31)

course "TAP_KIDS_MAR", name: "Tap Kids - Lunes", weekday: 1, valid_since: Date.new(2016,4,1), track: track("TAP_KIDS"), place: swing_city, start_time: '18:00' , valid_until: Date.new(2017,4,1)
course "TAP_KIDS_MIE", name: "Tap Kids - Miércoles", weekday: 3, valid_since: Date.new(2016,4,1), track: track("TAP_KIDS"), place: swing_city, start_time: '18:00', valid_until: Date.new(2018,3,31)
course "TAP_KIDS_JUE", name: "Tap Kids - Jueves", weekday: 4, valid_since: Date.new(2016,4,1), valid_until: Date.new(2016,4,2), track: track("TAP_KIDS"), place: swing_city, start_time: '18:00'

course "SWING_SENIOR_LUN", name: "Swing Senior - Lunes", weekday: 1, valid_since: Date.new(2016,7,1), track: track("SWING_SENIOR"), place: swing_city, start_time: '18:00' ,valid_until: Date.new(2017, 2, 28)
course "SWING_SENIOR_MIE", name: "Swing Senior - Miércoles", weekday: 3, valid_since: Date.new(2016,7,1), track: track("SWING_SENIOR"), place: swing_city, start_time: '18:00' ,valid_until: Date.new(2017, 2, 28)
course "SWING_SENIOR_SAB", name: "Swing Senior - Sábados", weekday: 6, valid_since: Date.new(2017,1,1), track: track("SWING_SENIOR"), place: swing_city, start_time: '16:00' ,valid_until: Date.new(2017, 6, 29)

course "BLUES_PRIN_JUE", name: "Blues - Principiantes - Jueves", weekday: 4, valid_since: Date.new(2018,1,1), track: track("BLUES_PRIN"), place: swing_city, start_time: '19:00'
course "BLUES_PRIN_VIE", name: "Blues - Principiantes - Viernes", weekday: 5, valid_since: Date.new(2017,8,1), valid_until: Date.new(2017,12,31), track: track("BLUES_PRIN"), place: swing_city, start_time: '20:00'

course "BLUES_INT1_JUE", name: "Blues - Intermedios 1 - Jueves", weekday: 4, valid_since: Date.new(2018,1,1), track: track("BLUES_INT1"), place: swing_city, start_time: '20:00'

course "BALBOA_PRIN_LUN", name: "Balboa - Principiantes - Lunes", weekday: 1, valid_since: Date.new(2019,1,1), track: track("BALBOA_PRIN"), place: swing_city, start_time: '20:00'

course "AERIALS_PRIN_JUE", name: "Aerials - Principiantes - Jueves", weekday: 4, valid_since: Date.new(2017,8,1), track: track("AERIALS_PRIN"), place: swing_city, start_time: '19:00', valid_until: Date.new(2018,12,31)
course "AERIALS_PRIN_JUE2", name: "Aerials - Principiantes - Jueves", weekday: 4, valid_since: Date.new(2019,2,1), track: track("AERIALS_PRIN"), place: swing_city, start_time: '19:00', valid_until: nil

course "AERIALS_INT1_JUE", name: "Aerials - Intermedios 1 - Jueves", weekday: 4, valid_since: Date.new(2017,11,1), valid_until: Date.new(2017,12,31), track: track("AERIALS_INT1"), place: swing_city, start_time: '20:00'

course "LH_COREO_JUE", name: "Lindy Hop Coreo - Jueves", weekday: 4, valid_since: Date.new(2017,8,1), track: track("LH_COREO"), place: swing_city, start_time: '20:00', valid_until: Date.new(2017, 10, 31)

course "INTRO_BAILE", name: "Intro al Baile - Sábados", weekday: 6, valid_since: Date.new(2018,1,1), track: track("INTRO_BAILE"), place: swing_city, start_time: '19:00', valid_until: Date.new(2018,12,31)

course "TEO_MUSICAL_VIE", name: "Teoría Musical - Viérnes", weekday: 5, valid_since: Date.new(2019,3,1), track: track("TEO_MUSICAL"), place: swing_city, start_time: '19:00', valid_until: Date.new(2019,3,31)

course "LOCKING_LUN", name: "Locking - Lunes", weekday: 1, valid_since: Date.new(2018,4,1), track: track("LOCKING"), place: swing_city, start_time: '17:00', valid_until: nil
course "HOUSE_LUN", name: "House - Lunes", weekday: 1, valid_since: Date.new(2018,4,1), track: track("HOUSE"), place: swing_city, start_time: '18:00', valid_until: Date.new(2018,12,31)
course "HOUSE_LUN2", name: "House - Lunes", weekday: 1, valid_since: Date.new(2019,2,1), track: track("HOUSE"), place: swing_city, start_time: '18:00', valid_until: nil
course "POPPING_MAR", name: "Popping - Martes", weekday: 2, valid_since: Date.new(2018,4,1), track: track("POPPING"), place: swing_city, start_time: '17:00', valid_until: Date.new(2018,9,30)
course "POPPING_JUE", name: "Popping - Jueves", weekday: 4, valid_since: Date.new(2018,10,1), track: track("POPPING"), place: swing_city, start_time: '18:00', valid_until: Date.new(2018,11,30)
course "WAACKING_MAR", name: "Waacking - Martes", weekday: 2, valid_since: Date.new(2018,4,1), track: track("WAACKING"), place: swing_city, start_time: '18:00', valid_until: Date.new(2018,9,30)
course "WAACKING_JUE", name: "Waacking - Jueves", weekday: 4, valid_since: Date.new(2018,10,1), track: track("WAACKING"), place: swing_city, start_time: '17:00', valid_until: Date.new(2018,11,30)
course "BREAKING", name: "Breaking - Miércoles", weekday: 3, valid_since: Date.new(2018,4,1), track: track("BREAKING"), place: swing_city, start_time: '18:00', valid_until: Date.new(2018,11,30)

course "HIP_HOP_PRIN_JUE", name: "Hip Hop - Principiantes - Jueves", weekday: 4, valid_since: Date.new(2018,4,1), track: track("HIP_HOP_PRIN"), place: swing_city, start_time: '17:00', valid_until: Date.new(2018,12,31)
course "HIP_HOP_INT_JUE", name: "Hip Hop - Intermedios - Jueves", weekday: 4, valid_since: Date.new(2018,4,1), track: track("HIP_HOP_INT"), place: swing_city, start_time: '18:00', valid_until: Date.new(2018,12,31)

course "DANZA_AFRO_MAR", name: "Danza Afro - Martes", weekday: 2, valid_since: Date.new(2018,4,1), track: track("DANZA_AFRO"), place: swing_city, start_time: '17:00', valid_until: nil

course "AFRO_URBANO_MIE", name: "Afro Urbano - Miércoles", weekday: 3, valid_since: Date.new(2018,12,1), track: track("AFRO_URBANO"), place: swing_city, start_time: '18:00', valid_until: nil
course "AFRO_URBANO_VIE", name: "Afro Urbano - Viernes", weekday: 5, valid_since: Date.new(2018,12,1), track: track("AFRO_URBANO"), place: swing_city, start_time: '18:00', valid_until: nil

payment_plan "LIBRE", description: "Swing: 1 Mes. Libre", price: 2800, weekly_classes: 40, order: 1, course_match: "swing"
payment_plan "2_MESES_LIBRE", description: "Swing: 2 Meses. Libre", price: 4600, weekly_classes: 40, order: 1, course_match: "swing"
payment_plan "3_MESES", description: "Swing: 3 Meses 1 x Semana", price: 1950, weekly_classes: 1, order: 1, course_match: "swing"
payment_plan "3_X_SEMANA", description: "Swing: Mensual 3 x Semana", price: 1900, weekly_classes: 3, order: 1, course_match: "swing"
payment_plan "2_X_SEMANA", description: "Swing: Mensual 2 x Semana", price: 1700, weekly_classes: 2, order: 1, course_match: "swing"
payment_plan "1_X_SEMANA_3", description: "Swing: Mensual 1 x Semana (3 c)", price: 680, weekly_classes: 1, order: 1, course_match: "swing"
payment_plan "1_X_SEMANA_4", description: "Swing: Mensual 1 x Semana (4 c)", price: 900, weekly_classes: 1, order: 1, course_match: "swing"
payment_plan "1_X_SEMANA_5", description: "Swing: Mensual 1 x Semana (5 c)", price: 1120, weekly_classes: 1, order: 1, course_match: "swing"
payment_plan PaymentPlan::SINGLE_CLASS, description: "Swing: Clase suelta", price: 270, weekly_classes: 1, order: 1, course_match: "swing"
payment_plan PaymentPlan::OTHER, description: "Swing: Otro (monto a continuación)", price: 0, weekly_classes: 1, order: 1, course_match: "swing"
payment_plan "1_X_SEMANA_4_SALE_30", description: "Swing: Mensual 1 x Semana (4 c) -30%", price: 630, weekly_classes: 1, order: 2, course_match: "swing"
payment_plan "1_X_SEMANA_4_SALE_50", description: "Swing: Mensual 1 x Semana (4 c) -50%", price: 450, weekly_classes: 1, order: 2, course_match: "swing"
payment_plan PaymentPlan::SINGLE_CLASS_FREE, description: "Swing: Clase bonificada", price: 0, weekly_classes: 1, order: 2, course_match: "swing"

payment_plan PaymentPlan::SINGLE_CLASS_ROOTS, description: "Roots: Clase suelta", price: 270, weekly_classes: 1, order: 3, course_match: "roots"
payment_plan "ROOTS__1_X_SEMANA", description: "Roots: Mensual 1 x Semana", price: 900, weekly_classes: 1, order: 3, course_match: "roots"
payment_plan "ROOTS__2_X_SEMANA", description: "Roots: Mensual 2 x Semana", price: 1700, weekly_classes: 2, order: 3, course_match: "roots"
payment_plan "ROOTS__3_X_SEMANA", description: "Roots: Mensual 3 x Semana", price: 2200, weekly_classes: 3, order: 3, course_match: "roots"

payment_plan PaymentPlan::SINGLE_CLASS_AFRO, description: "Roots: Clase suelta de Danza Afro", price: 300, weekly_classes: 1, order: 4, course_match: "afro"
payment_plan "AFRO__1_X_SEMANA", description: "Roots: Mensual 1 x Semana de Danza Afro", price: 1100, weekly_classes: 1, order: 4, course_match: "afro"
payment_plan "AFRO-1ROOTS__2_X_SEMANA", description: "Roots: Mensual 2 x Semana con Danza Afro", price: 1800, weekly_classes: 1, order: 4, course_match: "afro,roots"
payment_plan "AFRO-2ROOTS__3_X_SEMANA", description: "Roots: Mensual 3 x Semana con Danza Afro", price: 2600, weekly_classes: 1, order: 4, course_match: "afro,roots"

payment_plan "1_X_SEMANA_3_CASH", description: "Swing: Mensual 1 x Semana (3 c) - EFECTIVO", price: 2000, weekly_classes: 1, order: 1, course_match: "swing"
payment_plan "1_X_SEMANA_4_CASH", description: "Swing: Mensual 1 x Semana (4 c) - EFECTIVO", price: 2600, weekly_classes: 1, order: 1, course_match: "swing"
payment_plan "1_X_SEMANA_5_CASH", description: "Swing: Mensual 1 x Semana (5 c) - EFECTIVO", price: 3200, weekly_classes: 1, order: 1, course_match: "swing"
payment_plan "3_X_SEMANA_CASH", description: "Swing: Mensual 3 x Semana - EFECTIVO", price: 4400, weekly_classes: 3, order: 1, course_match: "swing"
payment_plan "2_X_SEMANA_CASH", description: "Swing: Mensual 2 x Semana - EFECTIVO", price: 6200, weekly_classes: 2, order: 1, course_match: "swing"
payment_plan "LIBRE_CASH", description: "Swing: 1 Mes. Libre - EFECTIVO", price: 10000, weekly_classes: 40, order: 1, course_match: "swing"
payment_plan "3_MESES_CASH", description: "Swing: 3 Meses 1 x Semana - EFECTIVO", price: 0, weekly_classes: 1, order: 1, course_match: "swing"



fixed_fee FixedFee::NEW_CARD, name: "Tarjeta Nueva", value: 50.0
