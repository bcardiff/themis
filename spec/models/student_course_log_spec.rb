require 'rails_helper'

RSpec.describe StudentCourseLog, type: :model do
  describe "factory" do
    it "should create" do
      create(:student_course_log)
    end
  end

  describe "validates" do
    it "should requires student" do
      expect(build(:student_course_log, student: nil)).to_not be_valid
    end

    it "should requires course_log" do
      expect(build(:student_course_log, course_log: nil)).to_not be_valid
    end

    it "teacher is in course_log" do
      student_log = build(:student_course_log, course_log: create(:course_log))
      expect(student_log.teacher).to_not be_nil
      student_log.validate
      expect(student_log).to have_error_on(:teacher)
    end

    it "must have a teacher when paying" do
      student_log = build(:student_course_log, teacher: nil, payment_plan: create(:payment_plan))
      student_log.validate
      expect(student_log).to have_error_on(:teacher)
    end

    it "can have no teacher when no paying" do
      student_log = build(:student_course_log, teacher: nil, payment_plan: nil)
      student_log.validate
      expect(student_log).to be_valid
    end
  end

  describe "activity_logs" do
    it "should create" do
      student = create(:student_course_log).student
      expect(student.activity_logs).to_not be_empty
    end
  end

end
