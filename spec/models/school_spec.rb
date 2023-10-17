require 'rails_helper'

RSpec.describe School, type: :model do
  let!(:plan_clase) { create(:payment_plan, code: PaymentPlan::SINGLE_CLASS, price: 70, weekly_classes: 1) }

  describe 'courses incomes' do
    let(:teacher) { create(:teacher, fee: 100) }
    let(:plan) { create(:payment_plan) }

    it 'count in the day they where transferred' do
      Timecop.freeze(Time.local(2015, 5, 15))
      transfer_payments_for(2)
      Timecop.freeze(Time.local(2015, 5, 20))
      transfer_payments_for(2)
      Timecop.freeze(Time.local(2015, 6, 1))
      transfer_payments_for(3)
      Timecop.return

      expect(School.course_incomes_per_month(Time.local(2015, 5, 1))).to eq(4 * plan.price)
      expect(School.course_incomes_per_month(Time.local(2015, 6, 15))).to eq(3 * plan.price)
    end

    def transfer_payments_for(number_of_students)
      number_of_students.times do
        create(:student_course_log, teacher: teacher, payment_plan: plan)
      end
      teacher.transfer_cash_income_money(plan.price * number_of_students, Time.now)
    end
  end

  describe 'teaching expenses' do
    let(:teacher) { create(:teacher, fee: 100) }
    let(:teacher2) { create(:teacher, fee: 150) }

    it 'uses current fee of teachers' do
      teacher_course_log = create(:teacher_course_log, teacher: teacher)
      create(:teacher_course_log, teacher: teacher)
      create(:teacher_course_log, teacher: teacher2)

      expect(teacher_course_log.paid_amount).to be_nil

      expect(School.course_teaching_expense_to_paid).to eq((100 * 2) + 150)

      teacher.fee = 170
      teacher.save!

      expect(School.course_teaching_expense_to_paid).to eq((170 * 2) + 150)
    end
  end
end
