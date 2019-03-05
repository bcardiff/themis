require 'rails_helper'

RSpec.describe Course, type: :model do
  describe "calendar name" do
    let(:course_lh_prin) { create(:course, code: 'LH_PRIN_JUE', track: create(:track, code: 'LH_PRIN', name: 'Lindy Hop - Principiantes')) }
    let(:course_lh_int1) { create(:course, code: 'LH_INT1_JUE', track: create(:track, code: 'LH_INT1', name: 'Lindy Hop - Intermedios')) }
    let(:course_estira) { create(:course, code: 'ESTIRA_SAB', track: create(:track, code: 'ESTIRAMIENTO', name: 'Estiramiento')) }
    let(:course_prep) { create(:course, code: 'PREP_SAB', track: create(:track, code: 'PREP_FISICA', name: 'Preparación Física')) }
    let(:course_balboa) { create(:course, code: 'BALBOA_SHAG_JUE', track: create(:track, code: 'BALBOA_SHAG', name: 'Balboa/Shag')) }

    it "should grab track code" do
      expect(course_lh_prin.description(:short_track)).to eq('LH PRIN')
      expect(course_lh_int1.description(:short_track)).to eq('LH INT1')
      expect(course_estira.description(:short_track)).to eq('ESTIRAMIENTO')
      expect(course_prep.description(:short_track)).to eq('PREP FISICA')
      expect(course_balboa.description(:short_track)).to eq('BALBOA SHAG')
    end
  end
end
