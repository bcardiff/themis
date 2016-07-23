require 'rails_helper'

RSpec.describe Course, type: :model do
  describe "calendar name" do
    let(:course_lh_prin) { create(:course, code: 'LH_PRIN_JUE', track: create(:track, code: 'LH_PRIN')) }
    let(:course_lh_int1) { create(:course, code: 'LH_INT1_JUE', track: create(:track, code: 'LH_INT1')) }
    let(:course_estira) { create(:course, code: 'ESTIRA_SAB', track: create(:track, code: 'ESTIRAMIENTO')) }
    let(:course_prep) { create(:course, code: 'PREP_SAB', track: create(:track, code: 'PREP_FISICA')) }
    let(:course_balboa) { create(:course, code: 'BALBOA_SHAG_JUE', track: create(:track, code: 'BALBOA_SHAG')) }

    it "should grab track code" do
      expect(course_lh_prin.name_with_wday_as_context).to eq('LH PRIN')
      expect(course_lh_int1.name_with_wday_as_context).to eq('LH INT1')
      expect(course_estira.name_with_wday_as_context).to eq('ESTIRAMIENTO')
      expect(course_prep.name_with_wday_as_context).to eq('PREP FISICA')
      expect(course_balboa.name_with_wday_as_context).to eq('BALBOA SHAG')
    end
  end
end
