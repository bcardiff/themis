require 'rails_helper'

RSpec.describe 'admin/welcome/index.html.haml', type: :view do
  it 'displays' do
    assign(:course_logs, {})

    render
  end
end
