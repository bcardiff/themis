class AddIdKindToStudentCourseLogs < ActiveRecord::Migration[7.0]
  def change
    add_column :student_course_logs, :id_kind, :string
  end
end
