require 'rails_helper'

RSpec.describe StudentPack, type: :model do
  describe 'factory' do
    it 'should create' do
      create(:student_pack)
    end
  end

  let!(:plan_3_meses) { create(:payment_plan, code: '3_MESES', price: 550, weekly_classes: 1) }
  let!(:plan_3_x_semana) { create(:payment_plan, code: '3_X_SEMANA', price: 500, weekly_classes: 3) }
  let!(:plan_2_x_semana) { create(:payment_plan, code: '2_X_SEMANA', price: 400, weekly_classes: 2) }
  let!(:plan_1_x_semana_3) { create(:payment_plan, code: '1_X_SEMANA_3', price: 180, weekly_classes: 1) }
  let!(:plan_1_x_semana_4) { create(:payment_plan, code: '1_X_SEMANA_4', price: 250, weekly_classes: 1) }
  let!(:plan_1_x_semana_5) { create(:payment_plan, code: '1_X_SEMANA_5', price: 300, weekly_classes: 1) }
  let!(:plan_clase) { create(:payment_plan, code: PaymentPlan::SINGLE_CLASS, price: 70, weekly_classes: 1) }
  let!(:plan_otro) { create(:payment_plan, code: PaymentPlan::OTHER) }

  let(:student) { create(:student) }
  let(:invalid_price) { plan_clase.price + 10 }

  it 'should create 3 month' do
    pack = StudentPack.register_for(student, Time.new(2015, 7, 10), plan_3_meses.price)
    student_pack = StudentPack.where(student: student).first
    expect(pack).to eq(student_pack)
    expect(student_pack).to_not be_nil
    expect(student_pack.payment_plan).to eq(plan_3_meses)
    expect(student_pack.start_date).to eq(Date.new(2015, 7, 1))
    expect(student_pack.due_date).to eq(Date.new(2015, 9, 30))
    expect(student_pack.max_courses).to eq(14)
  end

  it 'should create 3 per week' do
    StudentPack.register_for(student, Time.new(2015, 7, 2), plan_3_x_semana.price)
    student_pack = StudentPack.where(student: student).first
    expect(student_pack.payment_plan).to eq(plan_3_x_semana)
    expect(student_pack.start_date).to eq(Date.new(2015, 7, 1))
    expect(student_pack.due_date).to eq(Date.new(2015, 7, 31))
    expect(student_pack.max_courses).to eq(5 * 3)
  end

  it 'should create 2 per week' do
    StudentPack.register_for(student, Time.new(2015, 7, 2), plan_2_x_semana.price)
    student_pack = StudentPack.where(student: student).first
    expect(student_pack.payment_plan).to eq(plan_2_x_semana)
    expect(student_pack.start_date).to eq(Date.new(2015, 7, 1))
    expect(student_pack.due_date).to eq(Date.new(2015, 7, 31))
    expect(student_pack.max_courses).to eq(5 * 2)
  end

  it 'should create 1 per week in a 5 week month' do
    StudentPack.register_for(student, Time.new(2015, 7, 2), plan_1_x_semana_5.price)
    student_pack = StudentPack.where(student: student).first
    expect(student_pack.payment_plan).to eq(plan_1_x_semana_5)
    expect(student_pack.start_date).to eq(Date.new(2015, 7, 1))
    expect(student_pack.due_date).to eq(Date.new(2015, 7, 31))
    expect(student_pack.max_courses).to eq(5)
  end

  it 'should create 1 per week in a 4 week month' do
    StudentPack.register_for(student, Time.new(2015, 7, 2), plan_1_x_semana_4.price)
    student_pack = StudentPack.where(student: student).first
    expect(student_pack.payment_plan).to eq(plan_1_x_semana_4)
    expect(student_pack.start_date).to eq(Date.new(2015, 7, 1))
    expect(student_pack.due_date).to eq(Date.new(2015, 7, 31))
    expect(student_pack.max_courses).to eq(4)
  end

  it 'should create 1 per week in a 3 week month' do
    StudentPack.register_for(student, Time.new(2015, 7, 2), plan_1_x_semana_3.price)
    student_pack = StudentPack.where(student: student).first
    expect(student_pack.payment_plan).to eq(plan_1_x_semana_3)
    expect(student_pack.start_date).to eq(Date.new(2015, 7, 1))
    expect(student_pack.due_date).to eq(Date.new(2015, 7, 31))
    expect(student_pack.max_courses).to eq(3)
  end

  it 'should create pack with equivalent classes when no plan is found' do
    pack = StudentPack.register_for(student, Time.new(2015, 7, 2), invalid_price)
    student_pack = StudentPack.where(student: student).first
    expect(student_pack).to_not be_nil
    expect(pack.payment_plan).to eq(plan_otro)
    expect(pack.max_courses).to eq(1)
  end
end
