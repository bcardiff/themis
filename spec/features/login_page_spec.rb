require 'rails_helper'

describe 'login page' do
  include_context 'swc context'

  context 'when a cashier user logs in' do
    before(:each) do
      goto_page Login do |page|
        page.email.set cajero.email
        page.password.set cajero.password
        page.submit.click
      end
    end

    it 'should redirect to cashier dashboard' do
      expect_page CashierDashboard
    end
  end
end
