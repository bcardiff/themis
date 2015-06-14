class AddDateToTeacherCashIncome < ActiveRecord::Migration
  def change
    add_column :teacher_cash_incomes, :date, :date
  end
end
