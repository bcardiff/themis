class CreateStudentPacks < ActiveRecord::Migration[7.0]
  def change
    create_table :student_packs do |t|
      t.references :student, index: true, foreign_key: true
      t.references :payment_plan, index: true, foreign_key: true
      t.date :start_date, null: false
      t.date :due_date, null: false
      t.integer :max_courses, null: false

      t.timestamps null: false
    end
  end
end
