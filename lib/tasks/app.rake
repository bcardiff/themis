namespace :app do
  desc "Build student_packs"
  task build_packs: :environment do
    single_class = PaymentPlan.find_by(code: PaymentPlan::SINGLE_CLASS)
    StudentCourseLog.where(payment_plan_id: single_class.id).update_all(requires_student_pack: false)

    [6,7,8].each do |month|
      date = Date.new(2015,month,01)

      student_ids = StudentCourseLog.joins(:course_log).where(course_logs: { date: date..date.at_end_of_month}).pluck(:student_id)
      student_ids.each do |student_id|
        StudentPack.recalculate(Student.find(student_id), date)
      end
    end
  end

end
