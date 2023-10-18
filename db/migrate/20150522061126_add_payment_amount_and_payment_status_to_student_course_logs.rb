class AddPaymentAmountAndPaymentStatusToStudentCourseLogs < ActiveRecord::Migration[7.0]
  def change
    add_column :student_course_logs, :payment_amount, :decimal
    add_column :student_course_logs, :payment_status, :string
  end
end
