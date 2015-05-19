FactoryGirl.define do
  factory :teacher do
    sequence :name do |n|
      "teacher_#{n}"
    end
  end
end
