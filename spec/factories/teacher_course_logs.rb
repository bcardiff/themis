FactoryGirl.define do
  factory :teacher_course_log do
    teacher nil
    course_log
    paid false
    paid_at nil
    paid_amount nil
  end
end
