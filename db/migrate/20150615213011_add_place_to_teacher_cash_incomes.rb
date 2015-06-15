class AddPlaceToTeacherCashIncomes < ActiveRecord::Migration
  def change
    add_reference :teacher_cash_incomes, :place, index: true, foreign_key: true
  end
end
