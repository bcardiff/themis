FactoryGirl.define do
  factory :fixed_fee do
    code 'MyString'
    name 'MyString'
    value '9.99'
  end

  factory :new_card_fixed_fee, class: FixedFee do
    code FixedFee::NEW_CARD
    name 'Nueva Tarjeta'
    value '50.00'
  end
end
