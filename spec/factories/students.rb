FactoryGirl.define do
  factory :student do
    sequence :first_name do |n|
      "nombre_#{n}"
    end
    sequence :last_name do |n|
      "alumno_#{n}"
    end
    sequence :email do |n|
      "alumno_#{n}@domain.com"
    end
    sequence :card_code do |n|
      "SWC/stu/#{n}"
    end
  end
end
