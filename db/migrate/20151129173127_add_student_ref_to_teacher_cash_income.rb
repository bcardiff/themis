class AddStudentRefToTeacherCashIncome < ActiveRecord::Migration[7.0]
  def up
    add_reference :teacher_cash_incomes, :student, index: true, foreign_key: true

    execute <<-SQL
      UPDATE teacher_cash_incomes SET student_id = (
        SELECT student_id
        FROM student_course_logs
        WHERE student_course_logs.id = teacher_cash_incomes.student_course_log_id
      )
      WHERE teacher_cash_incomes.student_course_log_id IS NOT NULL
    SQL
  end

  def down
    remove_reference :teacher_cash_incomes, :student, index: true, foreign_key: true
  end
end
