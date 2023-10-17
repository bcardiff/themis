require 'rails_helper'

describe 'home page' do
  it 'signs me in' do
    goto_page Home do |page|
      expect(page).to have_content 'Swing City'
    end
  end
end
