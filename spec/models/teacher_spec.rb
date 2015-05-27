require 'rails_helper'

RSpec.describe Teacher, type: :model do
  describe "receive all course money" do
    let(:teacher) { create(:teacher) }
    let(:plan) { create(:payment_plan) }

    before(:each) {
      create(:student_course_log, teacher: teacher, payment_plan: plan)
      create(:student_course_log, teacher: teacher, payment_plan: plan)
      create(:student_course_log, teacher: teacher, payment_plan: plan)
      teacher.reload

      expect(teacher.owed_student_payments).to eq(plan.price * 3)
      expect(plan.price).to_not eq(0)

      teacher.transfer_student_payments_money
    }

    it "should leave as there is no owed money" do
      expect(teacher.owed_student_payments).to eq(0)
    end

    it "should add them to class income account" do
      expect(School.course_income_account.balance.amount).to eq(plan.price * 3)
    end
  end
end
