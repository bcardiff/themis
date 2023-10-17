require 'rails_helper'

RSpec.describe StudentCourseLog, type: :model do
  let!(:plan_clase) { create(:payment_plan, code: PaymentPlan::SINGLE_CLASS, price: 70, weekly_classes: 1) }

  describe 'factory' do
    it 'should create' do
      create(:student_course_log)
    end
  end

  describe 'validates' do
    it 'should requires student' do
      expect(build(:student_course_log, student: nil)).to_not be_valid
    end

    it 'should requires course_log' do
      expect(build(:student_course_log, course_log: nil)).to_not be_valid
    end

    skip 'teacher is in course_log' do
      student_log = build(:student_course_log, course_log: create(:course_log))
      expect(student_log.teacher).to_not be_nil
      student_log.validate
      expect(student_log).to have_error_on(:teacher)
    end

    it 'must have a teacher when paying' do
      student_log = build(:student_course_log, teacher: nil, payment_plan: create(:payment_plan))
      student_log.validate
      expect(student_log).to have_error_on(:teacher)
    end

    it 'can have no teacher when no paying' do
      student_log = build(:student_course_log, teacher: nil, payment_plan: nil)
      student_log.validate
      expect(student_log).to be_valid
    end
  end

  describe 'student_packs' do
    it 'should require pack be default' do
      student_log = create(:student_course_log)
      expect(student_log.student_pack).to be_nil
      expect(student_log.requires_student_pack).to be_truthy
    end

    it 'should require when payed by class' do
      student_log = create(:student_course_log, payment_plan: plan_clase)
      expect(student_log.student_pack).to be_nil
      expect(student_log.requires_student_pack).to be_falsey
    end
  end

  describe 'activity_logs' do
    it 'should create' do
      student = create(:student_course_log).student
      expect(student.activity_logs).to_not be_empty
    end

    it 'should not be created twice' do
      student_log = create(:student_course_log, payment_plan: create(:payment_plan))
      first_count = student_log.student.activity_logs.count
      student_log.save!
      expect(student_log.student.activity_logs.count).to eq(first_count)
    end

    it 'should remove payment log' do
      student_log = create(:student_course_log, payment_plan: create(:payment_plan))
      first_count = student_log.student.activity_logs.count
      student_log.payment_plan = nil
      student_log.save!
      expect(student_log.student.activity_logs.count).to eq(first_count - 1)
    end

    it 'should update payment log message when payment is changed' do
      student_log = create(:student_course_log, payment_plan: create(:payment_plan, price: '20.00'))
      first_count = student_log.student.activity_logs.count

      expect(payment(student_log).description).to start_with('Abonó 20')
      student_log.payment_plan = create(:payment_plan, price: '30.00')
      student_log.save!
      expect(student_log.student.activity_logs.count).to eq(first_count)
      expect(payment(student_log).description).to start_with('Abonó 30')
    end

    def payment(student_log)
      ActivityLogs::Student::Payment.for(student_log.student, student_log).first
    end
  end
end
