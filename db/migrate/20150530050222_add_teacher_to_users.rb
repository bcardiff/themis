class AddTeacherToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :teacher, index: true, foreign_key: true
  end
end
