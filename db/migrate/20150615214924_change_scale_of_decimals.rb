class ChangeScaleOfDecimals < ActiveRecord::Migration[7.0]
  def up
    change_column :payment_plans, :price, :decimal, :precision => 10, :scale => 2
    change_column :student_course_logs, :payment_amount, :decimal, :precision => 10, :scale => 2
    change_column :teacher_cash_incomes, :payment_amount, :decimal, :precision => 10, :scale => 2
    change_column :teacher_course_logs, :paid_amount, :decimal, :precision => 10, :scale => 2
    change_column :teachers, :fee, :decimal, :precision => 10, :scale => 2
  end

  def down
    change_column :payment_plans, :price, :decimal, :precision => 10
    change_column :student_course_logs, :payment_amount, :decimal, :precision => 10
    change_column :teacher_cash_incomes, :payment_amount, :decimal, :precision => 10
    change_column :teacher_course_logs, :paid_amount, :decimal, :precision => 10
    change_column :teachers, :fee, :decimal, :precision => 10
  end
end
