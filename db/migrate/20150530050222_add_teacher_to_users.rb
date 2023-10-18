class AddTeacherToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :teacher, index: true, foreign_key: true
  end
end
