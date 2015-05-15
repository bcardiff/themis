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
      c = CourseLog.for_course_on_date(course_code, "2015-05-15")

      expect {
        c.save!
      }.to change{ CourseLog.count }.by(1)

      expect(c.course).to eq(course)
      expect(c.date).to eq(Date.new(2015, 5, 15))
    end

    it "should only one course_log per course, date" do
      c = CourseLog.for_course_on_date(course_code, "2015-05-15")
      c.save!

      c1 = CourseLog.for_course_on_date(course_code, "2015-05-15")
      expect {
        c1.save!
      }.to change{ CourseLog.count }.by(0)

      expect(c1).to eq(c)
    end
  end
end
