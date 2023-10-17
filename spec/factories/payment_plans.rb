FactoryGirl.define do
  factory :payment_plan do
    code 'MyString'
    description 'MyString'
    price '50.00'
    weekly_classes 1
    course_match 'swing'
  end
end
