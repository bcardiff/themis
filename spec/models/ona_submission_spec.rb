require 'rails_helper'

RSpec.describe OnaSubmission, type: :model do
  let(:lh_int1_jue) { create(:course) }
  let(:mariel) { create(:teacher) }

  it "process teacher giving a class" do
    issued_class({
      "date" => "2015-05-17",
      "course" => lh_int1_jue.code,
      "teachers" => mariel.name,
    })

    expect(mariel.teacher_course_log.count).to eq(1)
    expect(mariel.teacher_course_log.first.course).to eq(lh_int1_jue)
  end

  def issued_class(payload)
    s = OnaSubmission.new
    s.form = 'issued_class'
    s.data = payload
    s.process! true
    # if s.status != 'done'
    #   raise s.log
    # end

    entities = [mariel, lh_int1_jue]
    entities.map &:reload
  end
end
