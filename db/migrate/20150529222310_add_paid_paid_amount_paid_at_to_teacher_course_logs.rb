class AddPaidPaidAmountPaidAtToTeacherCourseLogs < ActiveRecord::Migration
  def change
    add_column :teacher_course_logs, :paid, :boolean
    add_column :teacher_course_logs, :paid_amount, :decimal
    add_column :teacher_course_logs, :paid_at, :datetime
  end
end
