class AddPaymentPlanToStudentCourseLogs < ActiveRecord::Migration
  def change
    add_reference :student_course_logs, :payment_plan, index: true, foreign_key: true
  end
end
