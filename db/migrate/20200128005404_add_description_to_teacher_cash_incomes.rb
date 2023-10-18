class AddDescriptionToTeacherCashIncomes < ActiveRecord::Migration[7.0]
  def change
    add_column :teacher_cash_incomes, :description, :string
  end
end
