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

  describe "fill_missings" do
    let!(:course) { create(:course, weekday: 2, valid_since: Date.new(2015, 5, 1)) }

    context "empty history" do
      before(:each) {
        allow(Date).to receive(:today).and_return(today)
        CourseLog.fill_missings
      }

      context "one day after the course" do
        let(:today) { Date.new(2015, 5, 6) }

        it "should create as missing" do
          expect(CourseLog.all.count).to eq(1)
          log = CourseLog.all.first

          expect(log.course).to eq(course)
          expect(log.date).to eq(today - 1.day)
          expect(log.missing).to be_truthy
        end
      end

      context "multiple weeks" do
        let(:today) { Date.new(2015, 5, 20) }

        it "should create as missing" do
          expect(CourseLog.all.count).to eq(3)

          expect(CourseLog.all.map(&:date)).to eq([Date.new(2015, 5, 5), Date.new(2015, 5, 12), Date.new(2015, 5, 19)])
          expect(CourseLog.all.map(&:missing)).to eq([true, true, true])
        end
      end
    end

    context "with history" do

      before(:each) {
        CourseLog.for_course_on_date(course.code, "2015-05-12")
        allow(Date).to receive(:today).and_return(today)
        CourseLog.fill_missings
      }

      context "on the same day of the course" do
        let(:today) { Date.new(2015, 5, 19) }

        it "should create as missing" do
          expect(CourseLog.missing.count).to eq(0)
        end
      end

      context "one day after the course" do
        let(:today) { Date.new(2015, 5, 27) }

        it "should create as missing" do
          expect(CourseLog.missing.count).to eq(2)
          expect(CourseLog.missing.map(&:date)).to eq([Date.new(2015, 5, 19), Date.new(2015, 5, 26)])
        end
      end
    end
  end

  describe "for_course_on_date" do
    let(:course) { create(:course, weekday: 5) }
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
    let(:course) { create(:course, weekday: 2) }
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