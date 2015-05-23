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

    # TODO it has teacher when paying
  end
end
