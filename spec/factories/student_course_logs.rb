FactoryGirl.define do
  factory :student_course_log do
    id_kind 'lorem'
    student
    teacher
    course_log { create :course_log, teacher: teacher }
    payload nil
  end
end
