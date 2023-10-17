require 'rails_helper'

RSpec.describe OnaSubmission, type: :model do
  let!(:plan_otro) { create(:payment_plan, code: PaymentPlan::OTHER) }
  let!(:plan_clase) { create(:payment_plan, code: PaymentPlan::SINGLE_CLASS, price: 70, weekly_classes: 1) }
  let!(:plan_3_meses) { create(:payment_plan, code: '3_MESES', price: 550, weekly_classes: 1) }
  let!(:plan_1_x_semana_4) { create(:payment_plan, code: '1_X_SEMANA_4', price: 250, weekly_classes: 1) }

  let(:lh_int1_jue) { create(:course, weekday: 4) }
  let(:ch_int2_jue) { create(:course, weekday: 4) }
  let(:mariel) { create(:teacher) }
  let(:manu) { create(:teacher) }

  it 'process teacher giving a class' do
    issued_class({
                   'date' => '2015-05-14',
                   'course' => lh_int1_jue.code,
                   'teacher' => mariel.name
                 })

    expect(mariel.teacher_course_logs.count).to eq(1)
    expect(mariel.teacher_course_logs.first.course).to eq(lh_int1_jue)
  end

  it 'fails if date does not match weekday' do
    expect(issued_invalid_class({
                                  'date' => '2015-05-15',
                                  'course' => lh_int1_jue.code
                                })).to have_error_on(:date)
  end

  it 'can create new student' do
    submit_student({
                     'student_repeat/id_kind' => 'new_card',
                     'student_repeat/card' => '465',
                     'student_repeat/email' => 'johndoe@email.com',
                     'student_repeat/first_name' => 'John',
                     'student_repeat/last_name' => 'Doe'
                   })

    student = Student.first
    course_log = CourseLog.first

    expect(Student.count).to eq(1)
    expect(student.card_code).to eq(student_card('465'))
    expect(Card.count).to eq(1)
    expect(Card.first.code).to eq(student_card('465'))
    expect(Card.first.student).to eq(student)

    student_course_log = course_log.student_course_logs.first
    expect(student_course_log).to_not be_nil
    expect(student_course_log.id_kind).to eq('new_card')
    expect(student_course_log.student).to eq(student)
    expect(student_course_log.payload).to eq({
      'student_repeat/id_kind' => 'new_card',
      'student_repeat/card' => '465',
      'student_repeat/email' => 'johndoe@email.com',
      'student_repeat/first_name' => 'John',
      'student_repeat/last_name' => 'Doe'
    }.to_json)
  end

  it 'can reprocess with a new student' do
    data = {
      'student_repeat/id_kind' => 'new_card',
      'student_repeat/card' => '465',
      'student_repeat/email' => 'johndoe@email.com',
      'student_repeat/first_name' => 'John'
    }

    submit_student(data)
    submit_student(data)

    expect(Student.count).to eq(1)
  end

  it 'can reprocess with a guest student' do
    data = {
      'student_repeat/id_kind' => 'guest',
      'student_repeat/first_name' => 'John'
    }

    s = submit_student(data)
    reprocess s

    expect(Student.count).to eq(1)
    expect(StudentCourseLog.count).to eq(1)
  end

  it 'different submissions creates diffrent guests student' do
    data = {
      'student_repeat/id_kind' => 'guest',
      'student_repeat/first_name' => 'John'
    }

    submit_student(data)
    submit_student(data)

    expect(Student.count).to eq(2)
    expect(StudentCourseLog.count).to eq(2)
  end

  it 'can assign existing student' do
    student = create(:student)

    submit_student({
                     'student_repeat/id_kind' => 'existing_card',
                     'student_repeat/card' => student.card_code
                   })

    course_log = CourseLog.first

    expect(Student.count).to eq(1)

    student_course_log = course_log.student_course_logs.first
    expect(student_course_log).to_not be_nil
    expect(student_course_log.student).to eq(student)
    expect(student_course_log.id_kind).to eq('existing_card')
    expect(student_course_log.payload).to eq({
      'student_repeat/id_kind' => 'existing_card',
      'student_repeat/card' => student.card_code
    }.to_json)
  end

  it 'can create new student' do
    submit_student({
                     'student_repeat/id_kind' => 'guest',
                     'student_repeat/email' => 'johndoe@email.com',
                     'student_repeat/first_name' => 'John',
                     'student_repeat/last_name' => 'Doe'
                   })

    student = Student.first
    course_log = CourseLog.first

    expect(Student.count).to eq(1)
    expect(student.card_code).to be_nil
    expect(student.email).to eq('johndoe@email.com')
    expect(student.first_name).to eq('John')

    student_course_log = course_log.student_course_logs.first
    expect(student_course_log).to_not be_nil
    expect(student_course_log.student).to eq(student)
    expect(student_course_log.id_kind).to eq('guest')
    expect(student_course_log.payload).to eq({
      'student_repeat/id_kind' => 'guest',
      'student_repeat/email' => 'johndoe@email.com',
      'student_repeat/first_name' => 'John',
      'student_repeat/last_name' => 'Doe'
    }.to_json)
  end

  it 'should no duplicate guest when reprocessing' do
    data = {
      'student_repeat/id_kind' => 'guest',
      'student_repeat/email' => 'johndoe@email.com',
      'student_repeat/first_name' => 'John'
    }

    submit_student(data)
    submit_student(data)

    expect(Student.count).to eq(1)
    expect(StudentCourseLog.count).to eq(1)
  end

  # TODO: should email be optional for guest students?

  it 'should ignore empty students' do
    submit_student({
                     'student_repeat/id_kind' => 'existing_card',
                     'student_repeat/card' => ''
                   }, {
                     'student_repeat/id_kind' => 'new_card',
                     'student_repeat/card' => '',
                     'student_repeat/email' => '',
                     'student_repeat/first_name' => ''
                   }, {
                     'student_repeat/id_kind' => 'guest',
                     'student_repeat/email' => '',
                     'student_repeat/first_name' => ''
                   })

    expect(Student.count).to eq(0)
    expect(StudentCourseLog.count).to eq(0)
  end

  it 'should add many students to course_log' do
    submit_student({
                     'student_repeat/id_kind' => 'guest',
                     'student_repeat/email' => 'johndoe@email.com',
                     'student_repeat/first_name' => 'John'
                   }, {
                     'student_repeat/id_kind' => 'guest',
                     'student_repeat/email' => 'mary@email.com',
                     'student_repeat/first_name' => 'Mary'
                   })

    expect(Student.count).to eq(2)
    expect(StudentCourseLog.count).to eq(2)
  end

  it 'should register pending payment of amount' do
    submit_student({
                     'student_repeat/id_kind' => 'guest',
                     'student_repeat/email' => 'johndoe@email.com',
                     'student_repeat/first_name' => 'John',
                     'student_repeat/do_payment' => 'yes',
                     'student_repeat/payment/kind' => plan_otro.code,
                     'student_repeat/payment/amount' => 45
                   })

    student_log = StudentCourseLog.first
    income = student_log.incomes.first

    expect(student_log.teacher).to eq(mariel)
    expect(student_log.payment_amount).to eq(45)
    expect(student_log.payment_plan).to eq(plan_otro)

    expect(income.payment_amount).to eq(45)
    expect(income.payment_status).to eq(TeacherCashIncome::PAYMENT_ON_TEACHER)
  end

  it 'should register pending payment of amount given by the plan' do
    plan = create(:payment_plan, price: 172)

    submit_student({
                     'student_repeat/id_kind' => 'guest',
                     'student_repeat/email' => 'johndoe@email.com',
                     'student_repeat/first_name' => 'John',
                     'student_repeat/do_payment' => 'yes',
                     'student_repeat/payment/kind' => plan.code
                   })

    student_log = StudentCourseLog.first
    income = student_log.incomes.first

    expect(student_log.teacher).to eq(mariel)
    expect(student_log.payment_amount).to eq(172)
    expect(student_log.payment_plan).to eq(plan)

    expect(income.payment_amount).to eq(172)
    expect(income.payment_status).to eq(TeacherCashIncome::PAYMENT_ON_TEACHER)
  end

  it "should create new student if advertised as existing but it doesn't" do
    submit_student({
                     'student_repeat/id_kind' => 'existing_card',
                     'student_repeat/card' => '245'
                   })

    expect(StudentCourseLog.count).to eq(1)
    expect(Student.count).to eq(1)

    student_log = StudentCourseLog.first
    expect(student_log.student.card_code).to eq(student_card('245'))
    expect(student_log.student.first_name).to eq(Student::UNKOWN)
    expect(student_log.student.email).to be_nil
  end

  it 'should update name and email when it was unkown' do
    submit_student({
                     'student_repeat/id_kind' => 'existing_card',
                     'student_repeat/card' => '245'
                   })

    submit_student(ch_int2_jue, {
                     'student_repeat/id_kind' => 'new_card',
                     'student_repeat/card' => '245',
                     'student_repeat/email' => 'johndoe@email.com',
                     'student_repeat/first_name' => 'John',
                     'student_repeat/last_name' => 'Doe'
                   })

    expect(Student.count).to eq(1)

    student_log = StudentCourseLog.first
    expect(student_log.student.card_code).to eq(student_card('245'))
    expect(student_log.student.first_name).to eq('John')
    expect(student_log.student.last_name).to eq('Doe')
    expect(student_log.student.email).to eq('johndoe@email.com')
  end

  it 'should not update the known by on second submission' do
    submit_student({
                     'student_repeat/id_kind' => 'guest',
                     'student_repeat/email' => 'johndoe@email.com',
                     'student_repeat/first_name' => 'John',
                     'student_repeat/last_name' => 'Doe',
                     'student_repeat/known_by' => 'google'
                   })

    expect(Student.count).to eq(1)
    expect(Student.first.known_by).to eq('google')

    submit_student(ch_int2_jue, {
                     'student_repeat/id_kind' => 'guest',
                     'student_repeat/email' => 'johndoe@email.com',
                     'student_repeat/first_name' => 'John',
                     'student_repeat/last_name' => 'Doe',
                     'student_repeat/known_by' => 'facebook'
                   })

    expect(Student.count).to eq(1)
    expect(Student.first.known_by).to eq('google')
  end

  it "should not update the known by on second submission if it's a new_card" do
    submit_student({
                     'student_repeat/id_kind' => 'guest',
                     'student_repeat/email' => 'johndoe@email.com',
                     'student_repeat/first_name' => 'John',
                     'student_repeat/last_name' => 'Doe',
                     'student_repeat/known_by' => 'google'
                   })

    submit_student(ch_int2_jue, {
                     'student_repeat/id_kind' => 'new_card',
                     'student_repeat/card' => '245',
                     'student_repeat/email' => 'johndoe@email.com',
                     'student_repeat/first_name' => 'John',
                     'student_repeat/last_name' => 'Doe',
                     'student_repeat/known_by' => 'facebook'
                   })

    expect(Student.count).to eq(1)
    expect(Student.first.known_by).to eq('google')
  end

  it "should set the known by on if it's a new_card" do
    submit_student({
                     'student_repeat/id_kind' => 'new_card',
                     'student_repeat/card' => '245',
                     'student_repeat/email' => 'johndoe@email.com',
                     'student_repeat/first_name' => 'John',
                     'student_repeat/last_name' => 'Doe',
                     'student_repeat/known_by' => 'google'
                   })

    expect(Student.count).to eq(1)
    expect(Student.first.known_by).to eq('google')
  end

  it 'should create guess without name if there is payment' do
    plan = create(:payment_plan)

    submit_student({
                     'student_repeat/id_kind' => 'guest',
                     'student_repeat/do_payment' => 'yes',
                     'student_repeat/payment/kind' => plan.code
                   })

    expect(Student.count).to eq(1)
    student_log = StudentCourseLog.first
    expect(student_log.student.first_name).to eq(Student::UNKOWN)
    expect(student_log.student.last_name).to eq(Student::UNKOWN)
    expect(student_log.student.email).to be_nil
    expect(student_log.payment_amount).to eq(plan.price)
    expect(student_log.payment_plan).to eq(plan)
  end

  it 'should avoid changing payment amount if it was already transferered to account'

  describe 'transactional processing' do
    it 'when teacher is missing and a payment is been submitted' do
      plan = create(:payment_plan)
      student = create(:student)

      submission = issued_class({
                                  'date' => '2015-05-14',
                                  'course' => lh_int1_jue.code,
                                  'student_repeat' => [{
                                    'student_repeat/id_kind' => 'guest',
                                    'student_repeat/do_payment' => 'yes',
                                    'student_repeat/payment/kind' => plan.code
                                  }, {
                                    'student_repeat/id_kind' => 'existing_card',
                                    'student_repeat/card' => student.card_code
                                  }]
                                }, false)

      expect(submission.status).to eq('error')
      expect(Student.count).to eq(1)
      expect(StudentCourseLog.count).to eq(0)
      expect(CourseLog.count).to eq(0)
      expect(OnaSubmission.count).to eq(1)
    end

    it 'when a record not found do to a plan' do
      plan = create(:payment_plan)

      submission = issued_class({
                                  'date' => '2015-05-14',
                                  'course' => lh_int1_jue.code,
                                  'teacher' => mariel.name,
                                  'student_repeat' => [{
                                    'student_repeat/id_kind' => 'guest',
                                    'student_repeat/do_payment' => 'yes',
                                    'student_repeat/payment/kind' => plan.code
                                  }, {
                                    'student_repeat/id_kind' => 'guest',
                                    'student_repeat/do_payment' => 'yes',
                                    'student_repeat/payment/kind' => 'wrong-plan-code'
                                  }]
                                }, false)

      expect(Student.count).to eq(0)
      expect(StudentCourseLog.count).to eq(0)
      expect(CourseLog.count).to eq(0)
      expect(submission.status).to eq('error')
      expect(OnaSubmission.count).to eq(1)
    end
  end

  describe 'card vs cardtxt' do
    it 'should use card when cardtxt empty' do
      submit_student({
                       'student_repeat/id_kind' => 'new_card',
                       'student_repeat/card' => '245',
                       'student_repeat/cardtxt' => '',
                       'student_repeat/email' => 'johndoe@email.com',
                       'student_repeat/first_name' => 'John'
                     })

      expect(Student.count).to eq(1)
      student_log = StudentCourseLog.first
      expect(student_log.student.card_code).to eq(student_card('245'))
    end

    it 'should use cardtxt when card empty' do
      submit_student({
                       'student_repeat/id_kind' => 'new_card',
                       'student_repeat/card' => '',
                       'student_repeat/cardtxt' => '245',
                       'student_repeat/email' => 'johndoe@email.com',
                       'student_repeat/first_name' => 'John'
                     })

      expect(Student.count).to eq(1)
      student_log = StudentCourseLog.first
      expect(student_log.student.card_code).to eq(student_card('245'))
    end

    it 'should use cardtxt when both provided' do
      submit_student({
                       'student_repeat/id_kind' => 'new_card',
                       'student_repeat/card' => '999',
                       'student_repeat/cardtxt' => '245',
                       'student_repeat/email' => 'johndoe@email.com',
                       'student_repeat/first_name' => 'John'
                     })

      expect(Student.count).to eq(1)
      student_log = StudentCourseLog.first
      expect(student_log.student.card_code).to eq(student_card('245'))
    end
  end

  it 'should fail if other payment is choosen without amount'

  it 'should record secondary teacher as giving the class' do
    issued_class({
                   'date' => '2015-05-14',
                   'course' => lh_int1_jue.code,
                   'teacher' => mariel.name,
                   'secondary_teacher' => manu.name
                 })

    expect(mariel.teacher_course_logs.count).to eq(1)
    expect(mariel.teacher_course_logs.first.course).to eq(lh_int1_jue)

    expect(manu.teacher_course_logs.count).to eq(1)
    expect(manu.teacher_course_logs.first.course).to eq(lh_int1_jue)
  end

  it 'should schedule pending payment for main teacher' do
    issued_class({
                   'date' => '2015-05-14',
                   'course' => lh_int1_jue.code,
                   'teacher' => mariel.name
                 })

    expect(mariel.teacher_course_logs.first.paid).to eq(false)
  end

  it 'should schedule pending payment for secondary teacher' do
    issued_class({
                   'date' => '2015-05-14',
                   'course' => lh_int1_jue.code,
                   'teacher' => mariel.name,
                   'secondary_teacher' => manu.name
                 })

    expect(manu.teacher_course_logs.first.paid).to eq(false)
  end

  it 'reg bug' do
    issued_class({
                   'student_repeat' => [
                     {
                       'student_repeat/id_kind' => 'existing_card',
                       'student_repeat/do_payment' => 'no',
                       'student_repeat/card' => '322'
                     }
                   ],
                   'course' => lh_int1_jue.code,
                   'date' => '2015-05-14',
                   'teacher' => mariel.name
                 })

    expect(mariel.teacher_course_logs.count).to eq(1)
    expect(StudentCourseLog.first.teacher).to eq(mariel)
    expect(StudentCourseLog.first.course_log.teacher_course_logs.first.teacher).to eq(mariel)
  end

  it 'reg bug with payment' do
    plan = create(:payment_plan)

    issued_class({
                   'student_repeat' => [
                     {
                       'student_repeat/id_kind' => 'existing_card',
                       'student_repeat/card' => '322',
                       'student_repeat/do_payment' => 'yes',
                       'student_repeat/payment/kind' => plan.code
                     }
                   ],
                   'course' => lh_int1_jue.code,
                   'date' => '2015-05-14',
                   'teacher' => mariel.name
                 })

    expect(mariel.teacher_course_logs.count).to eq(1)
    expect(StudentCourseLog.first.teacher).to eq(mariel)
    expect(StudentCourseLog.first.course_log.teacher_course_logs.first.teacher).to eq(mariel)
  end

  it 'should remove payment if second submission stands it'
  it 'should reject negative payments amount'

  it 'should allow known student by email to get a new card' do
    submit_student({
                     'student_repeat/id_kind' => 'guest',
                     'student_repeat/email' => 'johndoe@email.com',
                     'student_repeat/first_name' => 'John'
                   })

    submit_student({
                     'student_repeat/id_kind' => 'new_card',
                     'student_repeat/card' => '999',
                     'student_repeat/email' => 'johndoe@email.com',
                     'student_repeat/first_name' => 'John'
                   })

    expect(Student.first.card_code).to eq(student_card('999'))
  end

  it 'should allow known student by email to get a new card in other class' do
    submit_student({
                     'student_repeat/id_kind' => 'guest',
                     'student_repeat/email' => 'johndoe@email.com',
                     'student_repeat/first_name' => 'John'
                   })

    issued_class({
                   'date' => '2015-05-21',
                   'course' => lh_int1_jue.code,
                   'teacher' => mariel.name,
                   'student_repeat' => [{
                     'student_repeat/id_kind' => 'new_card',
                     'student_repeat/card' => '999',
                     'student_repeat/email' => 'johndoe@email.com',
                     'student_repeat/first_name' => 'John'
                   }]
                 })

    expect(Student.first.card_code).to eq(student_card('999'))
  end

  describe 'student_packs check' do
    let(:card_code) { '322' }
    let(:date_in_first_week) { Date.new(2015, 8, 6) }
    let(:date_in_second_week) { date_in_first_week + 1.week }
    let(:date_in_third_week) { date_in_second_week + 1.week }
    let(:date_in_fourth_week) { date_in_third_week + 1.week }
    let(:date_in_first_week_of_second_month) { Date.new(2015, 9, 3) }
    let(:date_in_first_week_of_third_month) { Date.new(2015, 10, 1) }
    let(:date_in_first_week_of_fourth_month) { Date.new(2015, 11, 5) }

    def class_with_payment(date, plan, course = lh_int1_jue)
      issued_class({
                     'student_repeat' => [
                       {
                         'student_repeat/id_kind' => 'existing_card',
                         'student_repeat/card' => card_code,
                         'student_repeat/do_payment' => 'yes',
                         'student_repeat/payment/kind' => plan.code
                       }
                     ],
                     'course' => course.code,
                     'date' => date.strftime('%Y-%m-%d'),
                     'teacher' => mariel.name
                   })

      student_course_log_of date, course
    end

    def class_with_custom_payment(date, amount)
      issued_class({
                     'student_repeat' => [
                       {
                         'student_repeat/id_kind' => 'existing_card',
                         'student_repeat/card' => card_code,
                         'student_repeat/do_payment' => 'yes',
                         'student_repeat/payment/kind' => plan_otro.code,
                         'student_repeat/payment/amount' => amount
                       }
                     ],
                     'course' => lh_int1_jue.code,
                     'date' => date.strftime('%Y-%m-%d'),
                     'teacher' => mariel.name
                   })

      student_course_log_of date, lh_int1_jue
    end

    def class_without_payment(date, course = lh_int1_jue)
      issued_class({
                     'student_repeat' => [
                       {
                         'student_repeat/id_kind' => 'existing_card',
                         'student_repeat/card' => card_code,
                         'student_repeat/do_payment' => 'no'
                       }
                     ],
                     'course' => course.code,
                     'date' => date.strftime('%Y-%m-%d'),
                     'teacher' => mariel.name
                   })

      student_course_log_of date, course
    end

    def student_course_log_of(date, course = lh_int1_jue)
      Student.find_by_card(card_code).student_course_logs.includes(:course_log).where(course_logs: { date: date,
                                                                                                     course_id: course.id }).first
    end

    it 'should be ok to pay a single class' do
      first_log = class_with_payment date_in_first_week, plan_clase

      expect(first_log.requires_student_pack).to be_falsey
      expect(StudentCourseLog.missing_payment).to_not include(first_log)
    end

    it 'should not be ok to take a class without a pack' do
      first_log = class_without_payment date_in_first_week

      expect(first_log.requires_student_pack).to be_truthy
      expect(first_log.student_pack).to be_nil
      expect(StudentCourseLog.missing_payment).to include(first_log)
    end

    it 'should be ok to pay for the pack the first class of the month' do
      first_log = class_with_payment date_in_first_week, plan_1_x_semana_4

      expect(first_log.requires_student_pack).to be_truthy

      first_log.student_pack.tap do |pack|
        expect(pack).to_not be_nil
        expect(pack.student).to eq(Student.find_by_card(card_code))
        expect(pack.payment_plan).to eq(plan_1_x_semana_4)
        expect(pack.start_date).to eq(Date.new(2015, 8, 1))
        expect(pack.due_date).to eq(Date.new(2015, 8, 31))
        expect(pack.max_courses).to eq(4)
      end

      expect(StudentCourseLog.missing_payment).to_not include(first_log)
    end

    it 'should be ok to pay for the pack the second class of the month' do
      first_log = class_without_payment date_in_first_week
      second_log = class_with_payment date_in_second_week, plan_1_x_semana_4

      first_log.reload

      expect(StudentCourseLog.missing_payment).to_not include(first_log)
      expect(StudentCourseLog.missing_payment).to_not include(second_log)

      expect(first_log.student_pack).to_not be_nil
      expect(first_log.student_pack).to eq(second_log.student_pack)
    end

    it 'should be ok to fullfil the pay for the pack the second class of the month' do
      partial_price = 100
      first_log = class_with_custom_payment date_in_first_week, partial_price
      second_log = class_with_custom_payment date_in_second_week, plan_1_x_semana_4.price - partial_price

      first_log.reload

      expect(StudentCourseLog.missing_payment).to be_empty
      expect(first_log.student_pack).to eq(second_log.student_pack)

      first_log.student_pack.tap do |pack|
        expect(pack).to_not be_nil
        expect(pack.student).to eq(Student.find_by_card(card_code))
        expect(pack.payment_plan).to eq(plan_1_x_semana_4)
        expect(pack.start_date).to eq(Date.new(2015, 8, 1))
        expect(pack.due_date).to eq(Date.new(2015, 8, 31))
        expect(pack.max_courses).to eq(4)
      end
    end

    it 'should be ok to have clases in other month of the 3 month pack' do
      class_with_payment date_in_first_week, plan_3_meses
      class_without_payment date_in_second_week
      class_without_payment date_in_first_week_of_second_month
      class_without_payment date_in_first_week_of_third_month

      expect(StudentCourseLog.missing_payment).to be_empty
    end

    it 'should not be ok to have more clases than allowed' do
      class_with_payment date_in_first_week, plan_1_x_semana_4
      class_without_payment date_in_second_week
      class_without_payment date_in_third_week
      class_without_payment date_in_fourth_week

      expect(StudentCourseLog.missing_payment).to be_empty

      # class_without_payment of another class
      issued_class({
                     'student_repeat' => [
                       {
                         'student_repeat/id_kind' => 'existing_card',
                         'student_repeat/card' => card_code,
                         'student_repeat/do_payment' => 'no'
                       }
                     ],
                     'course' => ch_int2_jue.code,
                     'date' => date_in_fourth_week.strftime('%Y-%m-%d'),
                     'teacher' => mariel.name
                   })

      expect(StudentCourseLog.missing_payment).to_not be_empty
    end

    it 'should not be ok to have clases after the valid period' do
      class_with_payment date_in_first_week, plan_1_x_semana_4
      class_without_payment date_in_first_week_of_second_month

      expect(StudentCourseLog.missing_payment).to_not be_empty
    end

    it 'should be ok to pay two clases together in the second week' do
      class_without_payment date_in_first_week
      expect(StudentCourseLog.missing_payment).to_not be_empty

      class_with_custom_payment date_in_first_week, plan_clase.price * 2
      expect(StudentCourseLog.missing_payment).to be_empty
    end

    it 'should not be ok to pay two clases together in the third week' do
      class_without_payment date_in_first_week
      class_without_payment date_in_second_week
      expect(StudentCourseLog.missing_payment.count).to eq(2)

      class_with_custom_payment date_in_third_week, plan_clase.price * 2
      expect(StudentCourseLog.missing_payment.count).to eq(1)
    end

    it 'should be able to mark as not payed if payment was deleted' do
      class_with_payment date_in_first_week, plan_1_x_semana_4
      expect(StudentCourseLog.missing_payment).to be_empty

      class_without_payment date_in_first_week
      expect(StudentCourseLog.missing_payment).to_not be_empty
    end

    it 'should be able to mark as not payed if payment was deleted on other class' do
      class_with_payment date_in_first_week, plan_1_x_semana_4
      class_without_payment date_in_second_week
      expect(StudentCourseLog.missing_payment).to be_empty

      class_without_payment date_in_first_week
      expect(StudentCourseLog.missing_payment.count).to eq(2)
    end

    it 'should be able to mark as not payed if payment was updated' do
      class_with_payment date_in_first_week, plan_1_x_semana_4
      class_without_payment date_in_second_week
      student_log_third_week = class_without_payment date_in_third_week
      expect(StudentCourseLog.missing_payment).to be_empty
      # first_class = class_with_custom_payment date_in_first_week, plan_clase.price * 2
      expect(StudentCourseLog.missing_payment.count).to eq(1)
      expect(StudentCourseLog.missing_payment).to include(student_log_third_week)
    end

    it 'should be able to mark as not payed if payment was updated to single class' do
      class_with_payment date_in_first_week, plan_1_x_semana_4
      student_log_second_week = class_without_payment date_in_second_week
      expect(StudentCourseLog.missing_payment).to be_empty

      first_class = class_with_payment date_in_first_week, plan_clase
      expect(StudentCourseLog.missing_payment.count).to eq(1)
      expect(StudentCourseLog.missing_payment).to include(student_log_second_week)
      expect(first_class.requires_student_pack).to be_falsey
    end

    it 'should be able to mark as not payed if payment was updated on other class' do
      student_log_first_week = class_without_payment date_in_first_week
      class_with_payment date_in_second_week, plan_1_x_semana_4
      expect(StudentCourseLog.missing_payment).to be_empty

      second_class = class_with_payment date_in_second_week, plan_clase
      expect(StudentCourseLog.missing_payment.count).to eq(1)
      expect(StudentCourseLog.missing_payment).to include(student_log_first_week)
      expect(second_class.requires_student_pack).to be_falsey
    end

    describe 'should consume packs that are more proximate to expire first' do
      it 'when longer was created first' do
        class_with_payment date_in_first_week, plan_3_meses
        class_with_payment date_in_second_week, plan_1_x_semana_4
        last_class = class_without_payment date_in_third_week

        expect(last_class.student_pack.payment_plan).to eq(plan_1_x_semana_4)
      end

      it 'when longer was created later' do
        class_with_payment date_in_first_week, plan_1_x_semana_4
        class_with_payment date_in_second_week, plan_3_meses
        last_class = class_without_payment date_in_third_week

        expect(last_class.student_pack.payment_plan).to eq(plan_1_x_semana_4)
      end

      it 'should consume longer once the shorter is completely consumed' do
        class_with_payment date_in_first_week, plan_3_meses, lh_int1_jue
        class_with_payment date_in_first_week, plan_1_x_semana_4, ch_int2_jue
        class_without_payment date_in_second_week, lh_int1_jue
        c0 = class_without_payment date_in_second_week, ch_int2_jue
        c1 = class_without_payment date_in_third_week, lh_int1_jue
        c2 = class_without_payment date_in_third_week, ch_int2_jue

        expect(c0.student_pack.payment_plan).to eq(plan_1_x_semana_4)
        expect(c1.student_pack.payment_plan).to eq(plan_1_x_semana_4)
        expect(c2.student_pack.payment_plan).to eq(plan_3_meses)
      end
    end

    it 'should be able to have individual classes and a pack' do
      class_with_payment date_in_first_week, plan_1_x_semana_4
      class_without_payment date_in_second_week
      class_without_payment date_in_third_week
      class_without_payment date_in_fourth_week

      # class_with_payment of another class
      issued_class({
                     'student_repeat' => [
                       {
                         'student_repeat/id_kind' => 'existing_card',
                         'student_repeat/card' => card_code,
                         'student_repeat/do_payment' => 'yes',
                         'student_repeat/payment/kind' => plan_clase.code
                       }
                     ],
                     'course' => ch_int2_jue.code,
                     'date' => date_in_fourth_week.strftime('%Y-%m-%d'),
                     'teacher' => mariel.name
                   })

      expect(StudentCourseLog.missing_payment).to be_empty
    end

    it 'should be able to add another pack in parallel and consume it' do
      class_with_payment date_in_first_week, plan_3_meses
      class_without_payment date_in_second_week
      class_without_payment date_in_third_week
      class_without_payment date_in_fourth_week

      class_with_payment date_in_first_week_of_second_month, plan_1_x_semana_4

      pack1 = student_course_log_of(date_in_first_week).student_pack
      pack2 = student_course_log_of(date_in_first_week_of_second_month).student_pack

      expect(pack2).to_not eq(pack1)
      expect(pack1.student_course_logs.count).to eq(4)
      expect(pack2.student_course_logs.count).to eq(1)
    end

    it 'should not change pack of classes already assigned due to new paymets' do
      c1 = class_with_payment date_in_first_week, plan_3_meses
      c2 = class_with_payment date_in_second_week, plan_1_x_semana_4

      c1.reload
      expect(c1.student_pack.payment_plan).to eq(plan_3_meses)
      expect(c2.student_pack.payment_plan).to eq(plan_1_x_semana_4)
    end

    it 'should handle manually created payments that must not be deleted by the system'
  end

  describe 'new card' do
    before(:each) do
      submit_student({
                       'student_repeat/id_kind' => 'new_card',
                       'student_repeat/card' => '999',
                       'student_repeat/email' => 'johndoe@email.com',
                       'student_repeat/first_name' => 'John'
                     })
    end

    subject(:income) { TeacherCashIncomes::NewCardIncome.first }

    it 'record new card income' do
      expect(income).to_not be_nil
    end

    it 'create income with student' do
      expect(income.student.card_code).to eq(student_card('999'))
    end

    it 'create income with course_log' do
      expect(income.course_log).to eq(CourseLog.first)
    end

    it 'create income with teacher' do
      expect(income.teacher).to eq(mariel)
    end

    it 'tracks the income as pending' do
      expect(mariel.owed_cash_total).to eq(FixedFee.new_card_fee)
    end

    it 'should be able to assign new cards to same student by email' do
      # the following week a new card is issued
      issued_class({
                     'date' => '2015-05-21',
                     'course' => lh_int1_jue.code,
                     'teacher' => mariel.name,
                     'student_repeat' => [{
                       'student_repeat/id_kind' => 'new_card',
                       'student_repeat/card' => '888',
                       'student_repeat/email' => 'johndoe@email.com',
                       'student_repeat/first_name' => 'John'
                     }]
                   })

      expect(Student.count).to eq(1)
      expect(Student.first.cards.map(&:code)).to eq([student_card('999'), student_card('888')])
    end

    it 'should be able to assign existing card as new cards' do
      card = create(:card)

      # the following week a new card is issued
      submission = issued_class({
                                  'date' => '2015-05-21',
                                  'course' => lh_int1_jue.code,
                                  'teacher' => mariel.name,
                                  'student_repeat' => [{
                                    'student_repeat/id_kind' => 'new_card',
                                    'student_repeat/card' => card.code,
                                    'student_repeat/email' => 'johndoe@email.com',
                                    'student_repeat/first_name' => 'John'
                                  }]
                                }, false)

      expect(submission.status).to eq('error')
      expect(submission.log).to include("#{card.code} ya fue entregada")
    end
  end

  def issued_invalid_class(payload)
    result = nil

    begin
      issued_class(payload, true)
    rescue ActiveRecord::RecordInvalid => e
      result = e.record
    end

    result
  end

  def submit_student(*student_payload)
    if student_payload.first.is_a? Course
      course, *student_payload = student_payload
    else
      course = lh_int1_jue
    end

    issued_class({
                   'date' => '2015-05-14',
                   'course' => course.code,
                   'teacher' => mariel.name,
                   'student_repeat' => student_payload
                 })
  end

  def issued_class(payload, _raise = true)
    s = OnaSubmission.create form: 'issued_class', data: payload, status: 'pending'
    # result = s.process! _raise

    reload_entities

    s
  end

  def reprocess(ona_submission)
    ona_submission.process! true
    reload_entities
  end

  def reload_entities
    entities = [mariel, lh_int1_jue]
    entities.map(&:reload)
  end

  def student_card(code)
    Student.format_card_code(code)
  end
end
