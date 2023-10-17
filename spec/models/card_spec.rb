require 'rails_helper'

RSpec.describe Card, type: :model do
  describe 'factory' do
    it 'should create' do
      create(:card)
    end
  end

  describe 'validations' do
    it 'should accept student cards' do
      create(:card, code: 'SWC/stu/0007')
    end

    it 'should not accept wrong format' do
      expect(build(:card, code: 'XXX/yyy/0007')).to_not be_valid
      expect(build(:card, code: 'SWC/stu/000a')).to_not be_valid
    end

    it 'should not accept duplicate code' do
      card = create(:card)
      expect(build(:card, code: card.code)).to_not be_valid
    end
  end
end
