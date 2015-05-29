require 'rails_helper'

RSpec.describe School, type: :model do
  describe "courses incomes" do
    let(:teacher) { create(:teacher) }
    let(:plan) { create(:payment_plan) }


    it "count in the day they where transferred" do
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
      teacher.transfer_student_payments_money
    end
  end
end
