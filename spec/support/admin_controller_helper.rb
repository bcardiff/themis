module AdminControllerHelper
  extend ActiveSupport::Concern

  included do
    before(:each) do
      sign_in(create(:admin))
    end
  end
end
