FactoryGirl.define do
  factory :card do
    sequence :code do |n|
      "SWC/stu/#{'%.4d' % n}"
    end

    student nil
  end
end
