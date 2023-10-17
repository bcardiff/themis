require 'rails_helper'

RSpec.describe Place, type: :model do
  let(:caballito) { create(:place, name: Place::CABALLITO) }
  let(:place) { create(:place) }
  let(:caballito_course) { create(:course, weekday: 4, place: caballito) }
  let(:teacher) { create(:teacher) }
  let(:plan_1w) { create(:payment_plan, weekly_classes: 1) }
  let(:plan_2w) { create(:payment_plan, weekly_classes: 2) }
  let!(:plan_clase) { create(:payment_plan, code: PaymentPlan::SINGLE_CLASS, price: 70, weekly_classes: 1) }

  it 'should have commission if caballito' do
    expect(caballito.commission).to eq(0.3)
    expect(place.commission).to eq(0)
  end

  describe 'insurance on the first expense of the month' do
    before(:each) do
      submit_student({
                       'student_repeat/id_kind' => 'existing_card',
                       'student_repeat/card' => '465',
                       'student_repeat/email' => 'johndoe@email.com',
                       'student_repeat/first_name' => 'John',
                       'student_repeat/last_name' => 'Doe',
                       'student_repeat/do_payment' => 'yes',
                       'student_repeat/payment/kind' => plan_1w.code
                     })
    end

    it 'should split commission for place' do
      expect(caballito.expenses_total).to eq(caballito.insurance)
    end

    it 'should split income-commission for teacher' do
      expect(teacher.owed_cash_total).to eq(plan_1w.price - caballito.insurance)
    end
  end

  describe 'insurance on the class of the month event without payment' do
    before(:each) do
      submit_student({
                       'student_repeat/id_kind' => 'existing_card',
                       'student_repeat/card' => '465',
                       'student_repeat/email' => 'johndoe@email.com',
                       'student_repeat/first_name' => 'John',
                       'student_repeat/last_name' => 'Doe',
                       'student_repeat/do_payment' => 'no'
                     })
    end

    it 'should split commission for place' do
      expect(caballito.expenses_total).to eq(caballito.insurance)
    end

    it 'should split income-commission for teacher' do
      expect(teacher.owed_cash_total).to eq(-caballito.insurance)
    end
  end

  def assume_insurance
    TeacherCashIncomes::PlaceInsuranceExpense.create(teacher: teacher, payment_amount: 0, place: caballito,
                                                     date: Date.new(2015, 0o5, 0o7))
  end

  describe 'existing student payment' do
    before(:each) do
      assume_insurance

      submit_student({
                       'student_repeat/id_kind' => 'existing_card',
                       'student_repeat/card' => '465',
                       'student_repeat/email' => 'johndoe@email.com',
                       'student_repeat/first_name' => 'John',
                       'student_repeat/last_name' => 'Doe',
                       'student_repeat/do_payment' => 'yes',
                       'student_repeat/payment/kind' => plan_1w.code
                     })
    end

    it 'should split commission for place' do
      expect(caballito.expenses_total).to eq(plan_1w.price * caballito.commission)
    end

    it 'should split 1-commission for teacher' do
      expect(teacher.owed_cash_total).to eq(plan_1w.price * (1 - caballito.commission))
    end
  end

  describe 'new student payment' do
    before(:each) do
      assume_insurance

      submit_student({
                       'student_repeat/id_kind' => 'new_card',
                       'student_repeat/card' => '465',
                       'student_repeat/email' => 'johndoe@email.com',
                       'student_repeat/first_name' => 'John',
                       'student_repeat/last_name' => 'Doe',
                       'student_repeat/do_payment' => 'yes',
                       'student_repeat/payment/kind' => plan_1w.code
                     })
    end

    it 'should split commission for place without the card' do
      expect(caballito.expenses_total).to eq(plan_1w.price * caballito.commission)
    end

    it 'should split 1-commission for teacher without the card' do
      expect(teacher.owed_cash_total).to eq((plan_1w.price * (1 - caballito.commission)) + FixedFee.new_card_fee)
    end
  end

  describe 'student payment with multiple weekly classes' do
    before(:each) do
      assume_insurance

      submit_student({
                       'student_repeat/id_kind' => 'existing_card',
                       'student_repeat/card' => '465',
                       'student_repeat/email' => 'johndoe@email.com',
                       'student_repeat/first_name' => 'John',
                       'student_repeat/last_name' => 'Doe',
                       'student_repeat/do_payment' => 'yes',
                       'student_repeat/payment/kind' => plan_2w.code
                     })
    end

    it 'should split commission for place proportionally' do
      expect(caballito.expenses_total).to eq(plan_2w.price / 2.0 * caballito.commission)
    end

    it 'should split 1-commission for teacher proportionally' do
      expect(teacher.owed_cash_total).to eq(plan_2w.price - (plan_2w.price / 2.0 * caballito.commission))
    end
  end

  def submit_student(*student_payload)
    if student_payload.first.is_a? Course
      course, *student_payload = student_payload
    else
      course = caballito_course
    end

    issued_class({
                   'date' => '2015-05-14',
                   'course' => course.code,
                   'teacher' => teacher.name,
                   'student_repeat' => student_payload
                 })
  end

  def issued_class(payload, _raise = true)
    s = OnaSubmission.create form: 'issued_class', data: payload, status: 'pending'
    # result = s.process! _raise

    reload_entities

    s
  end

  def reload_entities
    entities = [teacher, caballito_course, caballito]
    entities.map(&:reload)
  end
end
