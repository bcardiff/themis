class AddCashierFlagToTeacher < ActiveRecord::Migration
  def change
    add_column :teachers, :cashier, :boolean, default: false, null: false
  end
end
