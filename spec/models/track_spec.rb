require 'rails_helper'

RSpec.describe Track, type: :model do
  let!(:a_track) { create(:track) }

  describe 'code' do
    it 'is required' do
      expect(build(:track, code: '')).to_not be_valid
      expect(build(:track, code: nil)).to_not be_valid
    end

    it 'is unique' do
      expect(build(:track, code: a_track.code)).to_not be_valid
    end

    it 'is an identifier' do
      expect(build(:track, code: 'some invalid')).to_not be_valid
      expect(build(:track, code: 'some_valid_9')).to be_valid
    end
  end
end
