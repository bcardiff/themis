class AddFeeToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :fee, :decimal
  end
end
