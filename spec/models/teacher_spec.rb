require 'rails_helper'

RSpec.describe Teacher, type: :model do
  let!(:plan_clase) { create(:payment_plan, code: PaymentPlan::SINGLE_CLASS, price: 70, weekly_classes: 1) }

  describe 'receive course money' do
    let(:teacher) { create(:teacher) }
    let(:plan) { create(:payment_plan) }

    before do
      Timecop.freeze Time.now.at_beginning_of_minute
    end

    after do
      Timecop.return
    end

    let!(:student_course_logs) do
      [create(:student_course_log, teacher: teacher, payment_plan: plan),
       create(:student_course_log, teacher: teacher, payment_plan: plan),
       create(:student_course_log, teacher: teacher, payment_plan: plan)]
    end

    let(:incomes) do
      student_course_logs.map(&:incomes).flatten
    end

    before(:each) do
      teacher.reload

      expect(teacher.owed_cash_total).to eq(plan.price * 3)
      expect(plan.price).to_not eq(0)

      teacher.transfer_cash_income_money(handed_money, Time.now)

      student_course_logs.map(&:reload)
    end

    shared_examples 'money handed' do
      it 'should leave as there is no owed money' do
        expect(teacher.owed_cash_total).to eq(0)
      end

      it 'should mark current time as transferred_at' do
        expect(student_course_logs.count).to eq(3)
        expect(incomes.count).to eq(3)
        expect(incomes.all? { |i| i.transferred_at == Time.now }).to be_truthy
      end

      it 'should add them to class income account' do
        expect(School.course_incomes_per_month(Time.now)).to eq(handed_money)
      end
    end

    context 'all the money' do
      let(:handed_money) { plan.price.to_i * 3 }

      it_behaves_like 'money handed'

      it 'should be no fix amount income' do
        expect(TeacherCashIncomes::FixAmountIncome.count).to eq(0)
      end
    end

    context 'fixed above amount' do
      let(:handed_money) { (plan.price.to_i * 3) + 10 }

      it_behaves_like 'money handed'

      it 'should be a fix amount income for the delta' do
        fix_amount = TeacherCashIncomes::FixAmountIncome.first
        expect(fix_amount.payment_amount).to eq(10)
      end
    end

    context 'fixed bellow amount' do
      let(:handed_money) { (plan.price.to_i * 3) - 10 }

      it 'should be a fix amount income for the delta' do
        fix_amount = TeacherCashIncomes::FixAmountIncome.first
        expect(fix_amount.payment_amount).to eq(-10)
      end
    end
  end

  describe 'pay pending classes' do
    let(:teacher) { create(:teacher) }

    before do
      Timecop.freeze Time.now.at_beginning_of_minute
    end

    after do
      Timecop.return
    end

    let!(:teacher_course_logs) do
      [create(:teacher_course_log, teacher: teacher),
       create(:teacher_course_log, teacher: teacher),
       create(:teacher_course_log, teacher: teacher)]
    end

    before(:each) do
      teacher.reload

      expect(teacher.due_salary_total).to eq(teacher.fee * 3)
      expect(teacher.fee).to_not eq(0)
      expect(teacher_course_logs.first.paid_amount).to be_nil

      teacher.pay_pending_classes(Time.now)

      teacher_course_logs.map(&:reload)
    end

    it 'should leave as there is no dued salary' do
      expect(teacher.due_salary_total).to eq(0)
    end

    it 'should mark current time as paid_at' do
      expect(teacher_course_logs.count).to eq(3)
      expect(teacher_course_logs.first.paid_at).to_not be_nil
      expect(teacher_course_logs.all? { |l| l.paid_at == Time.now }).to be_truthy
    end

    it 'should add them to teaching expense account' do
      expect(School.course_teaching_expense_per_month(Time.now)).to eq(teacher.fee * 3)
    end
  end
end
