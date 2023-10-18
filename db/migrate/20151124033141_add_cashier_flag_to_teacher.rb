class AddCashierFlagToTeacher < ActiveRecord::Migration[7.0]
  def change
    add_column :teachers, :cashier, :boolean, default: false, null: false
  end
end
