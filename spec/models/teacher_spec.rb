require 'rails_helper'

RSpec.describe Teacher, type: :model do
  describe "receive all course money" do
    let(:teacher) { create(:teacher) }
    let(:plan) { create(:payment_plan) }

    before do
      Timecop.freeze
    end

    after do
      Timecop.return
    end

    let!(:student_course_logs) {
      [create(:student_course_log, teacher: teacher, payment_plan: plan),
      create(:student_course_log, teacher: teacher, payment_plan: plan),
      create(:student_course_log, teacher: teacher, payment_plan: plan)]
    }

    before(:each) {
      teacher.reload

      expect(teacher.owed_student_payments).to eq(plan.price * 3)
      expect(plan.price).to_not eq(0)

      teacher.transfer_student_payments_money

      student_course_logs.map &:reload
    }

    it "should leave as there is no owed money" do
      expect(teacher.owed_student_payments).to eq(0)
    end

    it "should add them to class income account" do
      expect(School.course_incomes_per_month(Time.now)).to eq(plan.price * 3)
    end

    it "should mark current time as transferred_at" do
      expect(student_course_logs.count).to eq(3)
      expect(student_course_logs.first.transferred_at).to_not be_nil
      expect(student_course_logs.all? { |l| !l.transferred_at.nil? && l.transferred_at == Time.now }).to be_truthy
    end
  end
end
