require 'rails_helper'

RSpec.describe OnaController, type: :controller do

  describe "GET #json_post" do
    it "returns http success" do
      get :json_post
      expect(response).to have_http_status(:success)
    end
  end

end
