FactoryGirl.define do
  factory :course do
    sequence :name do |n|
      "course_#{n}"
    end
    place { Place.find_or_create_by(name: School.name) }
    track
    sequence :code do |n|
      "#{track.code}_#{n}"
    end
    weekday { 1 }
    valid_since { Date.new(2015, 5, 1) }
    start_time { '19:00' }
  end
end
