require 'rails_helper'

RSpec.describe CourseLog, type: :model do
  it "factory works" do
    create(:course_log)
  end

  it "validates presence of date" do
    c = build(:course_log, date: nil)
    expect(c.valid?).to be_falsey
  end

  it "validates presence of course" do
    c = build(:course_log, course: nil)
    expect(c.valid?).to be_falsey
  end

  describe "for_course_on_date" do
    let(:course) { create(:course) }
    let(:course_code) { course.code }

    it "should create new course_log" do
      c = nil

      expect {
        c = CourseLog.for_course_on_date(course_code, "2015-05-15")
      }.to change{ CourseLog.count }.by(1)

      expect(c.course).to eq(course)
      expect(c.date).to eq(Date.new(2015, 5, 15))
    end

    it "should only one course_log per course, date" do
      c = CourseLog.for_course_on_date(course_code, "2015-05-15")
      c1 = nil

      expect {
        c1 = CourseLog.for_course_on_date(course_code, "2015-05-15")
      }.to change{ CourseLog.count }.by(0)

      expect(c1).to eq(c)
    end
  end

  describe "teacher_course_logs" do
    let(:teacher) { create(:teacher) }
    let(:onther_teacher) { create(:teacher) }
    let(:course) { create(:course) }
    let(:course_log) { CourseLog.for_course_on_date(course.code, "2015-05-19") }

    it "should add teacher only" do
      expect {
        course_log.add_teacher teacher.name
      }.to change{ TeacherCourseLog.count }.by(1)
    end

    it "should add teacher only once" do
      course_log.add_teacher teacher.name

      expect {
        course_log.add_teacher teacher.name
      }.to change{ TeacherCourseLog.count }.by(0)
    end

    it "should add many teacher only once" do
      expect {
        course_log.add_teacher teacher.name
        course_log.add_teacher onther_teacher.name
      }.to change{ TeacherCourseLog.count }.by(2)
    end

    it "should raise if invalid teacher" do
      expect {
        course_log.add_teacher "invalid"
      }.to raise_error
    end
  end
end
