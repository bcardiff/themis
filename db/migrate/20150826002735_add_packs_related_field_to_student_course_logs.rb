class AddPacksRelatedFieldToStudentCourseLogs < ActiveRecord::Migration[7.0]
  def change
    add_column :student_course_logs, :requires_student_pack, :boolean, null: false, default: true
    add_reference :student_course_logs, :student_pack, index: true, foreign_key: true
  end
end
