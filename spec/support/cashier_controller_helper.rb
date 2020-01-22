module CashierControllerHelper
  extend ActiveSupport::Concern

  included do
    before(:each) do
      create(:place, name: School.description)
      sign_in(create(:cashier_user))
    end
  end
end
