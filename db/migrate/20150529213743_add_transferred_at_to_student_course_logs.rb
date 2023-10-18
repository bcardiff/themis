class AddTransferredAtToStudentCourseLogs < ActiveRecord::Migration[7.0]
  def change
    add_column :student_course_logs, :transferred_at, :datetime
  end
end
