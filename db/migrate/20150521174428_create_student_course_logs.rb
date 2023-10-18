class CreateStudentCourseLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :student_course_logs do |t|
      t.references :student, index: true, foreign_key: true
      t.references :course_log, index: true, foreign_key: true
      t.references :teacher, index: true, foreign_key: true
      t.text :payload

      t.timestamps null: false
    end
  end
end
