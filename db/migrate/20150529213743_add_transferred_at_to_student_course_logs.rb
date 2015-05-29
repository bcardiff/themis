class AddTransferredAtToStudentCourseLogs < ActiveRecord::Migration
  def change
    add_column :student_course_logs, :transferred_at, :datetime
  end
end
