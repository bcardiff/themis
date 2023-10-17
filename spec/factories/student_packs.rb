FactoryGirl.define do
  factory :student_pack do
    student nil
    payment_plan nil
    start_date '2015-07-29'
    due_date '2015-07-29'
    max_courses 1
  end
end
