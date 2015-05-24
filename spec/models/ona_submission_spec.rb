require 'rails_helper'

RSpec.describe OnaSubmission, type: :model do
  let(:lh_int1_jue) { create(:course, weekday: 4) }
  let(:ch_int2_jue) { create(:course, weekday: 4) }
  let(:mariel) { create(:teacher) }

  it "process teacher giving a class" do
    issued_class({
      "date" => "2015-05-14",
      "course" => lh_int1_jue.code,
      "teachers" => mariel.name,
    })

    expect(mariel.teacher_course_logs.count).to eq(1)
    expect(mariel.teacher_course_logs.first.course).to eq(lh_int1_jue)
  end

  it "fails if date does not match weekday" do
    expect(issued_invalid_class({
        "date" =>  "2015-05-15",
        "course" => lh_int1_jue.code
    })).to have_error_on(:date)
  end

  it "can create new student" do
    submit_student({
      "student_repeat/id_kind": "new_card",
      "student_repeat/card": "465",
      "student_repeat/email": "johndoe@email.com",
      "student_repeat/name": "John"
    })

    student = Student.first
    course_log = CourseLog.first

    expect(Student.count).to eq(1)
    expect(student.card_code).to eq("465")

    student_course_log = course_log.student_course_logs.first
    expect(student_course_log).to_not be_nil
    expect(student_course_log.student).to eq(student)
    expect(student_course_log.payload).to eq({
      "student_repeat/id_kind": "new_card",
      "student_repeat/card": "465",
      "student_repeat/email": "johndoe@email.com",
      "student_repeat/name": "John"
    }.to_json)
  end

  it "can reprocess with a new student" do
    data = {
      "student_repeat/id_kind": "new_card",
      "student_repeat/card": "465",
      "student_repeat/email": "johndoe@email.com",
      "student_repeat/name": "John"
    }

    submit_student(data)
    submit_student(data)

    expect(Student.count).to eq(1)
  end

  it "can reprocess with a guest student" do
    data = {
      "student_repeat/id_kind": "guest",
      "student_repeat/name": "John"
    }

    s = submit_student(data)
    reprocess s

    expect(Student.count).to eq(1)
    expect(StudentCourseLog.count).to eq(1)
  end

  it "different submissions creates diffrent guests student" do
    data = {
      "student_repeat/id_kind": "guest",
      "student_repeat/name": "John"
    }

    submit_student(data)
    submit_student(data)

    expect(Student.count).to eq(2)
    expect(StudentCourseLog.count).to eq(2)
  end

  it "can assign existing student" do
    student = create(:student)

    submit_student({
      "student_repeat/id_kind": "existing_card",
      "student_repeat/card": student.card_code
    })

    course_log = CourseLog.first

    expect(Student.count).to eq(1)

    student_course_log = course_log.student_course_logs.first
    expect(student_course_log).to_not be_nil
    expect(student_course_log.student).to eq(student)
    expect(student_course_log.payload).to eq({
      "student_repeat/id_kind": "existing_card",
      "student_repeat/card": student.card_code
    }.to_json)
  end

  it "can create new student" do
    submit_student({
      "student_repeat/id_kind": "guest",
      "student_repeat/email": "johndoe@email.com",
      "student_repeat/name": "John"
    })

    student = Student.first
    course_log = CourseLog.first

    expect(Student.count).to eq(1)
    expect(student.card_code).to be_nil
    expect(student.email).to eq("johndoe@email.com")
    expect(student.first_name).to eq("John")

    student_course_log = course_log.student_course_logs.first
    expect(student_course_log).to_not be_nil
    expect(student_course_log.student).to eq(student)
    expect(student_course_log.payload).to eq({
      "student_repeat/id_kind": "guest",
      "student_repeat/email": "johndoe@email.com",
      "student_repeat/name": "John"
    }.to_json)
  end

  it "should no duplicate guest when reprocessing" do
    data = {
      "student_repeat/id_kind": "guest",
      "student_repeat/email": "johndoe@email.com",
      "student_repeat/name": "John"
    }

    submit_student(data)
    submit_student(data)

    expect(Student.count).to eq(1)
    expect(StudentCourseLog.count).to eq(1)
  end

  # TODO should email be optional for guest students?

  it "should ignore empty students" do
    submit_student({
      "student_repeat/id_kind": "existing_card",
      "student_repeat/card": "",
    },{
      "student_repeat/id_kind": "new_card",
      "student_repeat/card": "",
      "student_repeat/email": "",
      "student_repeat/name": ""
    },{
      "student_repeat/id_kind": "guest",
      "student_repeat/email": "",
      "student_repeat/name": ""
    })

    expect(Student.count).to eq(0)
    expect(StudentCourseLog.count).to eq(0)
  end

  it "should add many students to course_log" do
    submit_student({
      "student_repeat/id_kind": "guest",
      "student_repeat/email": "johndoe@email.com",
      "student_repeat/name": "John"
    },{
      "student_repeat/id_kind": "guest",
      "student_repeat/email": "mary@email.com",
      "student_repeat/name": "Mary"
    })

    expect(Student.count).to eq(2)
    expect(StudentCourseLog.count).to eq(2)
  end

  it "should register pending payment of amount" do
    plan = create(:payment_plan, code: PaymentPlan::OTHER)

    submit_student({
      "student_repeat/id_kind": "guest",
      "student_repeat/email": "johndoe@email.com",
      "student_repeat/name": "John",
      "student_repeat/do_payment": "yes",
      "student_repeat/payment/kind": plan.code,
      "student_repeat/payment/amount": 45,
    })

    student_log = StudentCourseLog.first

    expect(student_log.teacher).to eq(mariel)
    expect(student_log.payment_amount).to eq(45)
    expect(student_log.payment_status).to eq(StudentCourseLog::PAYMENT_ON_TEACHER)
    expect(student_log.payment_plan).to eq(plan)
  end

  it "should register pending payment of amount given by the plan" do
    plan = create(:payment_plan, price: 172)

    submit_student({
      "student_repeat/id_kind": "guest",
      "student_repeat/email": "johndoe@email.com",
      "student_repeat/name": "John",
      "student_repeat/do_payment": "yes",
      "student_repeat/payment/kind": plan.code,
    })

    student_log = StudentCourseLog.first

    expect(student_log.teacher).to eq(mariel)
    expect(student_log.payment_amount).to eq(172)
    expect(student_log.payment_status).to eq(StudentCourseLog::PAYMENT_ON_TEACHER)
    expect(student_log.payment_plan).to eq(plan)
  end

  it "should create new student if advertised as existing but it doesn't" do
    submit_student({
      "student_repeat/id_kind": "existing_card",
      "student_repeat/card": "245"
    })

    expect(StudentCourseLog.count).to eq(1)
    expect(Student.count).to eq(1)

    student_log = StudentCourseLog.first
    expect(student_log.student.card_code).to eq("245")
    expect(student_log.student.first_name).to eq(Student::UNKOWN)
    expect(student_log.student.email).to be_nil
  end

  it "should update name and email when it was unkown" do
    submit_student({
      "student_repeat/id_kind": "existing_card",
      "student_repeat/card": "245"
    })

    submit_student(ch_int2_jue, {
      "student_repeat/id_kind": "new_card",
      "student_repeat/card": "245",
      "student_repeat/email": "johndoe@email.com",
      "student_repeat/name": "John",
    })

    expect(Student.count).to eq(1)

    student_log = StudentCourseLog.first
    expect(student_log.student.card_code).to eq("245")
    expect(student_log.student.first_name).to eq("John")
    expect(student_log.student.email).to eq("johndoe@email.com")
  end

  it "should create guess without name if there is payment" do
    plan = create(:payment_plan)

    submit_student({
      "student_repeat/id_kind": "guest",
      "student_repeat/do_payment": "yes",
      "student_repeat/payment/kind": plan.code
    })

    expect(Student.count).to eq(1)
    student_log = StudentCourseLog.first
    expect(student_log.student.first_name).to eq(Student::UNKOWN)
    expect(student_log.student.email).to be_nil
    expect(student_log.payment_amount).to eq(plan.price)
    expect(student_log.payment_plan).to eq(plan)
  end

  it "should avoid changing payment amount if it was already transferered to account"
  it "ensure invalid students do not block payment processing" # example bad payment plan
  it "support inteligent match of students cards"


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
      "date" => "2015-05-14",
      "course" => course.code,
      "teachers" => mariel.name,
      "student_repeat": student_payload
    })
  end

  def issued_class(payload, _raise = true)
    s = OnaSubmission.new
    s.form = 'issued_class'
    s.data = payload
    result = s.process! _raise

    reload_entities

    s
  end

  def reprocess(ona_submission)
    ona_submission.process! true
    reload_entities
  end

  def reload_entities
    entities = [mariel, lh_int1_jue]
    entities.map &:reload
  end
end
