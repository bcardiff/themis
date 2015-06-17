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

    it "email should be uniq" do
      student = create(:student)
      expect(build(:student, email: student.email)).to_not be_valid
    end

    it "can't change card_code" do
      student = create(:student, card_code: "111")
      student.card_code = "222"
      expect(student).to_not be_valid
    end

    it "can't remove card_code" do
      student = create(:student, card_code: "111")
      student.card_code = nil
      expect(student).to_not be_valid
    end

    it "can assign card_code" do
      student = create(:student, card_code: nil)
      student.card_code = "222"
      expect(student).to be_valid
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

  describe "import" do
    it "should create new student if fresh email and no card" do
      Student.import! "name", "last", "email@domain.com", ""
      expect(Student.count).to eq(1)
      student = Student.first
      expect(student.first_name).to eq("name")
      expect(student.last_name).to eq("last")
      expect(student.email).to eq("email@domain.com")
      expect(student.card_code).to be_nil
    end

    it "should create new student if fresh email and card" do
      Student.import! "name", "last", "email@domain.com", "123"
      expect(Student.count).to eq(1)
      student = Student.first
      expect(student.first_name).to eq("name")
      expect(student.last_name).to eq("last")
      expect(student.email).to eq("email@domain.com")
      expect(student.card_code).to eq("SWC/stu/0123")
    end

    it "should update student matching by email" do
      saved = create(:student, card_code: nil)

      Student.import! "name", "last", saved.email, "123"
      expect(Student.count).to eq(1)
      student = Student.first
      expect(student.first_name).to eq("name")
      expect(student.last_name).to eq("last")
      expect(student.email).to eq(saved.email)
      expect(student.card_code).to eq("SWC/stu/0123")
    end

    it "should update student matching by email without removing information" do
      saved = create(:student, card_code: nil, last_name: nil)

      Student.import! "", "last", saved.email, ""
      expect(Student.count).to eq(1)
      student = Student.first
      expect(student.first_name).to eq(saved.first_name)
      expect(student.last_name).to eq("last")
      expect(student.email).to eq(saved.email)
      expect(student.card_code).to eq(saved.card_code)
    end

    it "should update student matching by card_code" do
      saved = create(:student, email: nil)

      Student.import! "name", "last", "email@domain.com", saved.card_code
      expect(Student.count).to eq(1)
      student = Student.first
      expect(student.first_name).to eq("name")
      expect(student.last_name).to eq("last")
      expect(student.email).to eq("email@domain.com")
      expect(student.card_code).to eq(saved.card_code)
    end

    it "should update student matching by card_code without removing information" do
      saved = create(:student, email: nil, last_name: nil)

      Student.import! "", "last", "email@domain.com", saved.card_code
      expect(Student.count).to eq(1)
      student = Student.first
      expect(student.first_name).to eq(saved.first_name)
      expect(student.last_name).to eq("last")
      expect(student.email).to eq("email@domain.com")
      expect(student.card_code).to eq(saved.card_code)
    end

    it "should fail if trying to change card" do
      saved = create(:student, card_code: "111")

      expect {
        Student.import! "name", "last", saved.email, "222"
      }.to raise_error
    end

    it "should fail if trying to mix students" do
      saved1 = create(:student)
      saved2 = create(:student)

      expect {
        Student.import! "name", "last", saved1.email, saved2.card_code
      }.to raise_error
    end
  end
end
