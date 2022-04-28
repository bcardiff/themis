FactoryGirl.define do
  factory :payment_plan do
    code "MyString"
    description "MyString"
    price "50.00"
    weekly_classes 1
    course_match "swing"
    single_class false

    trait :single_class do
      code PaymentPlan::SINGLE_CLASS
      single_class true
      price "70.00"
      weekly_classes 1
    end

    trait :weekly_1_month do
      code "weekly_1_month"
      single_class false
      price "200.00"
      weekly_classes 1
      due_date_months 1
    end

    trait :biweekly_1_month do
      code "biweekly_1_month"
      single_class false
      price "400.00"
      weekly_classes 2
      due_date_months 1
    end
  end

end
