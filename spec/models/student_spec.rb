require 'rails_helper'

RSpec.describe Student, type: :model do
  describe "factory" do
    it "should create" do
      create(:student)
    end
  end

  describe "validates" do
    it "should requires name" do
      expect(build(:student, first_name: nil)).to_not be_valid
    end

    it "card_code should be uniq" do
      student = create(:student)
      expect(build(:student, card_code: student.card_code)).to_not be_valid
    end
  end

  describe "card code saved with slashes" do
    it "when input is number" do
      expect_card_code_saved_as("3457", "SWC/stu/3457")
    end

    it "when input is short number" do
      expect_card_code_saved_as("57", "SWC/stu/0057")
    end

    it "when input is with slash and number" do
      expect_card_code_saved_as("swc/stu/3457", "SWC/stu/3457")
    end

    it "when input is with slash and short number" do
      expect_card_code_saved_as("swc/stu/57", "SWC/stu/0057")
    end

    it "when input is with dash and number" do
      expect_card_code_saved_as("swc-stu-3457", "SWC/stu/3457")
    end

    it "when input is with dash and short number" do
      expect_card_code_saved_as("swc-stu-57", "SWC/stu/0057")
    end

    def expect_card_code_saved_as(card_code, saved_as)
      s = create(:student, card_code: card_code)
      expect(s.card_code).to eq(saved_as)

      expect(Student.format_card_code(card_code)).to eq(saved_as)
    end
  end

  describe "find_by_card" do
    let!(:student) { create(:student, card_code: '42')}

    it "should find card by number only" do
      expect(Student.find_by_card('42')).to eq(student)
      expect(Student.find_by_card('43')).to eq(nil)
    end

    it "should find card by code with slash" do
      expect(Student.find_by_card('SWC/stu/42')).to eq(student)
      expect(Student.find_by_card('SWC/stu/43')).to eq(nil)
      expect(Student.find_by_card('swc/STU/42')).to eq(student)
      expect(Student.find_by_card('swc/STU/43')).to eq(nil)
    end

    it "should find card by code with dash" do
      expect(Student.find_by_card('SWC-stu-42')).to eq(student)
      expect(Student.find_by_card('SWC-stu-43')).to eq(nil)
      expect(Student.find_by_card('swc-STU-42')).to eq(student)
      expect(Student.find_by_card('swc-STU-43')).to eq(nil)
    end

    it "should find card by code with spaces" do
      expect(Student.find_by_card('SWC stu 42')).to eq(student)
      expect(Student.find_by_card('SWC stu 43')).to eq(nil)
      expect(Student.find_by_card('swc STU 42')).to eq(student)
      expect(Student.find_by_card('swc STU 43')).to eq(nil)
    end
  end
end
