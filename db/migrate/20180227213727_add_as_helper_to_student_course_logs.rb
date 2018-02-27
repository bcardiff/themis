class AddAsHelperToStudentCourseLogs < ActiveRecord::Migration
  def change
    add_column :student_course_logs, :as_helper, :boolean, default: false, null: false
  end
end
