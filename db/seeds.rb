# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def course(code, attributes)
  Course.find_or_create_by(code: code).tap do |course|
    attributes.each do |key, value|
      course.send "#{key}=", value
    end
    course.save!
  end
end

Teacher.find_or_create_by name: 'Mariel'
Teacher.find_or_create_by name: 'Manuel'
Teacher.find_or_create_by name: 'Juani'
Teacher.find_or_create_by name: 'Candela'
Teacher.find_or_create_by name: 'Mariano'
Teacher.find_or_create_by name: 'Celeste'
Teacher.find_or_create_by name: 'Nanchi'

course "CH_AVAN_MIE", name: "Charleston - Avanzados - Miércoles Sendas"
course "CH_PRIN_MIE", name: "Charleston - Principiantes - Miércoles Sendas"
course "LH_AVAN_LUN", name: "Lindy Hop - Avanzados - Lunes colmegna"
course "LH_INT1_JUE", name: "Lindy Hop - Intermedios 1 - Jueves Vera"
course "LH_INT1_LUN", name: "Lindy Hop - Intermedios 1 - Lunes colmegna"
course "LH_INT1_MAR", name: "Lindy Hop - Intermedios 1 - Martes Gascon"
course "LH_INT1_MIE", name: "Lindy Hop - Intermedios 1 - Miércoles Vera"
course "LH_INT1_VIE", name: "Lindy Hop - Intermedios 1 - Viernes Malcom"
course "LH_INT2_JUE", name: "Lindy Hop - Intermedios 2 - Jueves Vera"
course "LH_INT2_LUN", name: "Lindy Hop - Intermedios 2 - Lunes colmegna"
course "LH_PRIN_JUE", name: "Lindy Hop - Principiantes - Jueves Vera"
course "LH_PRIN_LUN", name: "Lindy Hop - Principiantes - Lunes colmegna"
course "LH_PRIN_MAR2", name: "Lindy Hop - Principiantes - Martes Gascon"
course "LH_PRIN_MIE", name: "Lindy Hop - Principiantes - Miércoles colmegna"
course "LH_PRIN_MIE2", name: "Lindy Hop - Principiantes - Miércoles Vera"
course "LH_PRIN_SAB", name: "Lindy Hop - Principiantes - Sábados Sc"
course "LH_PRIN_VIE", name: "Lindy Hop - Principiantes - Viernes Iberá"
course "TP_INT1_MAR", name: "Tap - Intermedios 1 - Martes La huella"
course "TP_PRIN_MAR", name: "Tap - Principiantes - Martes La huella"
course "TP_PRIN_MIE", name: "Tap - Principiantes - Miércoles Medrano"
