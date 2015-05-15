FactoryGirl.define do
  factory :course do
    sequence :name do |n|
      "course_#{n}"
    end
    code { name }
  end
end
