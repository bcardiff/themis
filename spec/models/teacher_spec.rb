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
    }

    it "should initially have pending amount" do
      expect(teacher.classes_money_owed).to eq(plan.price * 3)
      expect(plan.price).to_not eq(0)
    end

    it "should leave as there is no owed money" do
      teacher.transfer_classes_money
      expect(teacher.classes_money_owed).to eq(0)
    end

    it "should add them to class income account"
  end
end
