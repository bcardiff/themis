module CashierControllerHelper
  extend ActiveSupport::Concern

  included do
    before(:each) do
      sign_in(create(:cashier_user))
    end
  end
end
