FactoryGirl.define do
  factory :course_log do
    course
    date { Date.today }
  end
end
