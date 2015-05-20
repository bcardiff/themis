FactoryGirl.define do
  factory :course do
    sequence :name do |n|
      "course_#{n}"
    end
    code { name }
    weekday { 1 }
    valid_since { Date.new(2015, 5, 1) }
  end
end
