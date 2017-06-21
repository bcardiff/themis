class AddPhoneToStudents < ActiveRecord::Migration
  def change
    add_column :students, :phone, :text
  end
end
