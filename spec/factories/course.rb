FactoryGirl.define do
  factory :course do
    sequence :name do |n|
      "course_#{n}"
    end
    track
    code { name }
    weekday { 1 }
    valid_since { Date.new(2015, 5, 1) }
  end
end
