require 'rails_helper'

RSpec.describe OnaSubmission, type: :model do
  let(:lh_int1_jue) { create(:course, weekday: 4) }
  let(:mariel) { create(:teacher) }

  it "process teacher giving a class" do
    issued_class({
      "date" => "2015-05-14",
      "course" => lh_int1_jue.code,
      "teachers" => mariel.name,
    })

    expect(mariel.teacher_course_log.count).to eq(1)
    expect(mariel.teacher_course_log.first.course).to eq(lh_int1_jue)
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
    issued_class({
      "date" => "2015-05-14",
      "course" => lh_int1_jue.code,
      "teachers" => mariel.name,
      "student_repeat": student_payload
    })
  end

  def issued_class(payload, _raise = true)
    s = OnaSubmission.new
    s.form = 'issued_class'
    s.data = payload
    result = s.process! _raise

    entities = [mariel, lh_int1_jue]
    entities.map &:reload
  end
end