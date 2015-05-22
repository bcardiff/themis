FactoryGirl.define do
  factory :student_course_log do
    student
    teacher
    course_log { create :course_log, teacher: teacher }
    payload nil
  end

end
