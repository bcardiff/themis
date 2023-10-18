class CreateTeacherCashIncomes < ActiveRecord::Migration[7.0]
  def change
    create_table :teacher_cash_incomes do |t|
      t.references :teacher, index: true, foreign_key: true
      t.string :type
      t.decimal :payment_amount
      t.string :payment_status
      t.datetime :transferred_at

      t.references :student_course_log, index: true, foreign_key: true
      t.references :course_log, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
