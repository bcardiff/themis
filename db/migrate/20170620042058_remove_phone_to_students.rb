class RemovePhoneToStudents < ActiveRecord::Migration
  def change
    remove_column :students, :phone, :text
  end
end
