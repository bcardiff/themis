require 'rails_helper'

RSpec.describe Cashier::StudentsController, type: :controller do
  include CashierControllerHelper
  let(:student_no_card) { create(:student, card_code: nil) }
  let(:student_with_card) { create(:student) }

  describe 'put #update' do
    it 'should create a new card income if card changes' do
      expect do
        post :update, id: student_no_card.id, place_id: Place.default.id, student: {
          first_name: student_no_card.first_name,
          last_name: student_no_card.last_name,
          email: student_no_card.email,
          card_code: '456'
        }
      end.to change { TeacherCashIncomes::NewCardIncome.count }.by(1)

      student_no_card.reload
      expect(student_no_card.card_code).to eq(Student.format_card_code('456'))
    end

    it 'should not create a new card income if card does not change' do
      expect do
        post :update, id: student_with_card.id, place_id: Place.default.id, student: {
          first_name: student_with_card.first_name,
          last_name: student_with_card.last_name,
          email: student_with_card.email,
          card_code: student_with_card.card_code
        }
      end.to change { TeacherCashIncomes::NewCardIncome.count }.by(0)
    end
  end
end
