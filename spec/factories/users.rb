FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "user_#{n}@domain.com"
    end
    password "password"
    admin false
  end

  factory :admin, class: User do
    sequence :email do |n|
      "user_#{n}@domain.com"
    end
    password "password"
    admin true
  end

end
