require 'rails_helper'

RSpec.describe OnaSubmission, type: :model do
  let(:lh_int1_jue) { create(:course, weekday: 4) }
  let(:ch_int2_jue) { create(:course, weekday: 4) }
  let(:mariel) { create(:teacher) }
  let(:manu) { create(:teacher) }

  it "process teacher giving a class" do
    issued_class({
      "date" => "2015-05-14",
      "course" => lh_int1_jue.code,
      "teacher" => mariel.name,
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
      "student_repeat/first_name": "John",
      "student_repeat/last_name": "Doe"
    })

    student = Student.first
    course_log = CourseLog.first

    expect(Student.count).to eq(1)
    expect(student.card_code).to eq(student_card("465"))

    student_course_log = course_log.student_course_logs.first
    expect(student_course_log).to_not be_nil
    expect(student_course_log.student).to eq(student)
    expect(student_course_log.payload).to eq({
      "student_repeat/id_kind": "new_card",
      "student_repeat/card": "465",
      "student_repeat/email": "johndoe@email.com",
      "student_repeat/first_name": "John",
      "student_repeat/last_name": "Doe"
    }.to_json)
  end

  it "can reprocess with a new student" do
    data = {
      "student_repeat/id_kind": "new_card",
      "student_repeat/card": "465",
      "student_repeat/email": "johndoe@email.com",
      "student_repeat/first_name": "John"
    }

    submit_student(data)
    submit_student(data)

    expect(Student.count).to eq(1)
  end

  it "can reprocess with a guest student" do
    data = {
      "student_repeat/id_kind": "guest",
      "student_repeat/first_name": "John"
    }

    s = submit_student(data)
    reprocess s

    expect(Student.count).to eq(1)
    expect(StudentCourseLog.count).to eq(1)
  end

  it "different submissions creates diffrent guests student" do
    data = {
      "student_repeat/id_kind": "guest",
      "student_repeat/first_name": "John"
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
      "student_repeat/first_name": "John",
      "student_repeat/last_name": "Doe"
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
      "student_repeat/first_name": "John",
      "student_repeat/last_name": "Doe"
    }.to_json)
  end

  it "should no duplicate guest when reprocessing" do
    data = {
      "student_repeat/id_kind": "guest",
      "student_repeat/email": "johndoe@email.com",
      "student_repeat/first_name": "John"
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
      "student_repeat/first_name": ""
    },{
      "student_repeat/id_kind": "guest",
      "student_repeat/email": "",
      "student_repeat/first_name": ""
    })

    expect(Student.count).to eq(0)
    expect(StudentCourseLog.count).to eq(0)
  end

  it "should add many students to course_log" do
    submit_student({
      "student_repeat/id_kind": "guest",
      "student_repeat/email": "johndoe@email.com",
      "student_repeat/first_name": "John"
    },{
      "student_repeat/id_kind": "guest",
      "student_repeat/email": "mary@email.com",
      "student_repeat/first_name": "Mary"
    })

    expect(Student.count).to eq(2)
    expect(StudentCourseLog.count).to eq(2)
  end

  it "should register pending payment of amount" do
    plan = create(:payment_plan, code: PaymentPlan::OTHER)

    submit_student({
      "student_repeat/id_kind": "guest",
      "student_repeat/email": "johndoe@email.com",
      "student_repeat/first_name": "John",
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
      "student_repeat/first_name": "John",
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
    expect(student_log.student.card_code).to eq(student_card("245"))
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
      "student_repeat/first_name": "John",
      "student_repeat/last_name": "Doe",
    })

    expect(Student.count).to eq(1)

    student_log = StudentCourseLog.first
    expect(student_log.student.card_code).to eq(student_card("245"))
    expect(student_log.student.first_name).to eq("John")
    expect(student_log.student.last_name).to eq("Doe")
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
    expect(student_log.student.last_name).to eq(Student::UNKOWN)
    expect(student_log.student.email).to be_nil
    expect(student_log.payment_amount).to eq(plan.price)
    expect(student_log.payment_plan).to eq(plan)
  end

  it "should avoid changing payment amount if it was already transferered to account"

  describe "transactional processing" do

    it "when teacher is missing and a payment is been submitted" do
      plan = create(:payment_plan)
      student = create(:student)

      submission = issued_class({
        "date" => "2015-05-14",
        "course" => lh_int1_jue.code,
        "student_repeat" => [{
          "student_repeat/id_kind" => "guest",
          "student_repeat/do_payment" => "yes",
          "student_repeat/payment/kind" => plan.code
        },{
          "student_repeat/id_kind": "existing_card",
          "student_repeat/card": student.card_code
        }]
      }, false)

      expect(submission.status).to eq('error')
      expect(Student.count).to eq(1)
      expect(StudentCourseLog.count).to eq(0)
      expect(CourseLog.count).to eq(0)
      expect(OnaSubmission.count).to eq(1)
    end

    it "when a record not found do to a plan" do
      plan = create(:payment_plan)

      submission = issued_class({
        "date" => "2015-05-14",
        "course" => lh_int1_jue.code,
        "teacher" => mariel.name,
        "student_repeat" => [{
          "student_repeat/id_kind" => "guest",
          "student_repeat/do_payment" => "yes",
          "student_repeat/payment/kind" => plan.code
        },{
          "student_repeat/id_kind" => "guest",
          "student_repeat/do_payment" => "yes",
          "student_repeat/payment/kind" => "wrong-plan-code"
        }]
      }, false)

      expect(Student.count).to eq(0)
      expect(StudentCourseLog.count).to eq(0)
      expect(CourseLog.count).to eq(0)
      expect(submission.status).to eq('error')
      expect(OnaSubmission.count).to eq(1)
    end
  end

  describe "card vs cardtxt" do
    it "should use card when cardtxt empty" do
      submit_student({
        "student_repeat/id_kind": "new_card",
        "student_repeat/card": "245",
        "student_repeat/cardtxt": "",
        "student_repeat/email": "johndoe@email.com",
        "student_repeat/first_name": "John",
      })

      expect(Student.count).to eq(1)
      student_log = StudentCourseLog.first
      expect(student_log.student.card_code).to eq(student_card("245"))
    end

    it "should use cardtxt when card empty" do
      submit_student({
        "student_repeat/id_kind": "new_card",
        "student_repeat/card": "",
        "student_repeat/cardtxt": "245",
        "student_repeat/email": "johndoe@email.com",
        "student_repeat/first_name": "John",
      })

      expect(Student.count).to eq(1)
      student_log = StudentCourseLog.first
      expect(student_log.student.card_code).to eq(student_card("245"))
    end

    it "should use cardtxt when both provided" do
      submit_student({
        "student_repeat/id_kind": "new_card",
        "student_repeat/card": "999",
        "student_repeat/cardtxt": "245",
        "student_repeat/email": "johndoe@email.com",
        "student_repeat/first_name": "John",
      })

      expect(Student.count).to eq(1)
      student_log = StudentCourseLog.first
      expect(student_log.student.card_code).to eq(student_card("245"))
    end
  end

  it "should fail if other payment is choosen without amount"

  it "should record secondary teacher as giving the class" do
    issued_class({
      "date" => "2015-05-14",
      "course" => lh_int1_jue.code,
      "teacher" => mariel.name,
      "secondary_teacher" => manu.name,
    })

    expect(mariel.teacher_course_logs.count).to eq(1)
    expect(mariel.teacher_course_logs.first.course).to eq(lh_int1_jue)

    expect(manu.teacher_course_logs.count).to eq(1)
    expect(manu.teacher_course_logs.first.course).to eq(lh_int1_jue)
  end

  it "should schedule pending payment for main teacher" do
    issued_class({
      "date" => "2015-05-14",
      "course" => lh_int1_jue.code,
      "teacher" => mariel.name
    })

    expect(mariel.teacher_course_logs.first.paid).to eq(false)
  end

  it "should schedule pending payment for secondary teacher" do
    issued_class({
      "date" => "2015-05-14",
      "course" => lh_int1_jue.code,
      "teacher" => mariel.name,
      "secondary_teacher" => manu.name,
    })

    expect(manu.teacher_course_logs.first.paid).to eq(false)
  end

  it "reg bug" do
    issued_class ({
      "student_repeat": [
        {
          "student_repeat/id_kind": "existing_card",
          "student_repeat/do_payment": "no",
          "student_repeat/card": "322"
        }
      ],
      "course": lh_int1_jue.code,
      "date": "2015-05-14",
      "teacher": mariel.name
    })

    expect(mariel.teacher_course_logs.count).to eq(1)
    expect(StudentCourseLog.first.teacher).to eq(mariel)
    expect(StudentCourseLog.first.course_log.teacher_course_logs.first.teacher).to eq(mariel)
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
      "date" => "2015-05-14",
      "course" => course.code,
      "teacher" => mariel.name,
      "student_repeat": student_payload
    })
  end

  def issued_class(payload, _raise = true)
    s = OnaSubmission.create form: 'issued_class', data: payload, status: 'pending'
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

  def student_card(code)
    Student.format_card_code(code)
  end

end
