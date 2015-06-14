class AddIdKindToStudentCourseLogs < ActiveRecord::Migration
  def change
    add_column :student_course_logs, :id_kind, :string
  end
end
