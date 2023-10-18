class CreateTeacherCourseLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :teacher_course_logs do |t|
      t.references :teacher, index: true, foreign_key: true
      t.references :course_log, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
