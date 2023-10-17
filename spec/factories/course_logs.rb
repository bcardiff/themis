FactoryGirl.define do
  factory :course_log do
    transient do
      teacher nil
    end
    course
    date { School.today.next_wday(course.weekday) - 1.week if course }

    after(:build) do |course_log, evaluator|
      course_log.add_teacher(evaluator.teacher.name) if evaluator.teacher
    end
  end
end
