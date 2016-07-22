FactoryGirl.define do
  factory :track do
    sequence :code do |n|
      "track_#{n}"
    end
  end
end
