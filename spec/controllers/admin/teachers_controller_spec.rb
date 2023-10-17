require 'rails_helper'

RSpec.describe Admin::TeachersController, type: :controller do
  include AdminControllerHelper

  let(:teacher) { create(:teacher) }

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #owed_cash' do
    it 'returns http success' do
      get :owed_cash, id: teacher
      expect(response).to have_http_status(:success)
    end
  end
end
