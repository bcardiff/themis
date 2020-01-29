class AddDescriptionToTeacherCashIncomes < ActiveRecord::Migration
  def change
    add_column :teacher_cash_incomes, :description, :string
  end
end
