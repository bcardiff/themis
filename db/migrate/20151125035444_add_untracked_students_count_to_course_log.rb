class AddUntrackedStudentsCountToCourseLog < ActiveRecord::Migration[7.0]
  def change
    add_column :course_logs, :untracked_students_count, :integer, default: 0, null: false
  end
end
