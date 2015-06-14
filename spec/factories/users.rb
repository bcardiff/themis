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
      "admin_#{n}@domain.com"
    end
    password "password"
    admin true
  end

  factory :teacher_user, class: User do
    sequence :email do |n|
      "teacher_#{n}@domain.com"
    end
    password "password"
    admin false
    teacher
  end
end
