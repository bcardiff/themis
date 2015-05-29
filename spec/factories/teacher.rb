FactoryGirl.define do
  factory :teacher do
    sequence :name do |n|
      "teacher_#{n}"
    end
    fee "150"
  end
end
