require 'rails_helper'

RSpec.describe Course, type: :model do
  describe "calendar name" do
    let(:course) { create(:course, code: 'LH_INT1_JUE')}

    it "should grab first two parts" do
      expect(course.calendar_name).to eq('LH INT1')
    end
  end
end
