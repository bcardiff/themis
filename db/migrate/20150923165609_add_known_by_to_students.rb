class AddKnownByToStudents < ActiveRecord::Migration
  def change
    add_column :students, :known_by, :string
  end
end
