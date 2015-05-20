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

  def issued_invalid_class(payload)
    result = nil

    begin
      issued_class(payload, true)
    rescue ActiveRecord::RecordInvalid => e
      result = e.record
    end

    result
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
