class AddFeeToTeachers < ActiveRecord::Migration[7.0]
  def change
    add_column :teachers, :fee, :decimal
  end
end
