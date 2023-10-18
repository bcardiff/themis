class CreateCourseLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :course_logs do |t|
      t.references :course
      t.date :date

      t.timestamps null: false
    end
  end
end
