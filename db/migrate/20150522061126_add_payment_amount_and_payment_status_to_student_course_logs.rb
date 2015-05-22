class AddPaymentAmountAndPaymentStatusToStudentCourseLogs < ActiveRecord::Migration
  def change
    add_column :student_course_logs, :payment_amount, :decimal
    add_column :student_course_logs, :payment_status, :string
  end
end
