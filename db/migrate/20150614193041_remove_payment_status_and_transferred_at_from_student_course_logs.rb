class RemovePaymentStatusAndTransferredAtFromStudentCourseLogs < ActiveRecord::Migration
  def change
    remove_column :student_course_logs, :payment_status, :string
    remove_column :student_course_logs, :transferred_at, :datetime
  end
end
