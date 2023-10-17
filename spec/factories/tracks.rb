FactoryGirl.define do
  factory :track do
    sequence :code do |n|
      "track_#{n}"
    end
    course_kind 'swing'
  end
end
