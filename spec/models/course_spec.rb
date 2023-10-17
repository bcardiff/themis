require 'rails_helper'

RSpec.describe Course, type: :model do
  let!(:a_course) { create(:course) }

  describe 'code' do
    it 'is required' do
      expect(build(:course, code: '')).to_not be_valid
      expect(build(:course, code: nil)).to_not be_valid
    end

    it 'is unique' do
      expect(build(:course, code: a_course.code)).to_not be_valid
    end

    it 'is an identifier' do
      expect(build(:course, code: 'some invalid')).to_not be_valid
      expect(build(:course, code: 'some_valid_9')).to be_valid
    end
  end

  describe '.next_code' do
    let!(:lh_avan) { create(:track, code: 'LH_AVAN') }

    it 'should use next available number' do
      expect(Course.next_code(lh_avan, 1)).to eq('LH_AVAN_LUN')

      create(:course, code: 'LH_AVAN_LUN')
      expect(Course.next_code(lh_avan, 1)).to eq('LH_AVAN_LUN2')
      expect(Course.next_code(lh_avan, 2)).to eq('LH_AVAN_MAR')

      create(:course, code: 'LH_AVAN_LUN3')
      expect(Course.next_code(lh_avan, 1)).to eq('LH_AVAN_LUN2')
      create(:course, code: 'LH_AVAN_LUN2')
      expect(Course.next_code(lh_avan, 1)).to eq('LH_AVAN_LUN4')
    end
  end

  describe 'calendar name' do
    let(:course_lh_prin) do
      create(:course, code: 'LH_PRIN_JUE', track: create(:track, code: 'LH_PRIN', name: 'Lindy Hop - Principiantes'))
    end
    let(:course_lh_int1) do
      create(:course, code: 'LH_INT1_JUE', track: create(:track, code: 'LH_INT1', name: 'Lindy Hop - Intermedios'))
    end
    let(:course_estira) do
      create(:course, code: 'ESTIRA_SAB', track: create(:track, code: 'ESTIRAMIENTO', name: 'Estiramiento'))
    end
    let(:course_prep) do
      create(:course, code: 'PREP_SAB', track: create(:track, code: 'PREP_FISICA', name: 'Preparación Física'))
    end
    let(:course_balboa) do
      create(:course, code: 'BALBOA_SHAG_JUE', track: create(:track, code: 'BALBOA_SHAG', name: 'Balboa/Shag'))
    end

    it 'should grab track code' do
      expect(course_lh_prin.description(:short_track)).to eq('LH PRIN')
      expect(course_lh_int1.description(:short_track)).to eq('LH INT1')
      expect(course_estira.description(:short_track)).to eq('ESTIRAMIENTO')
      expect(course_prep.description(:short_track)).to eq('PREP FISICA')
      expect(course_balboa.description(:short_track)).to eq('BALBOA SHAG')
    end
  end
end
