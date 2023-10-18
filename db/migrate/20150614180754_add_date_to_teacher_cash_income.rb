class AddDateToTeacherCashIncome < ActiveRecord::Migration[7.0]
  def change
    add_column :teacher_cash_incomes, :date, :date
  end
end
