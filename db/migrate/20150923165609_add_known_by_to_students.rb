class AddKnownByToStudents < ActiveRecord::Migration[7.0]
  def change
    add_column :students, :known_by, :string
  end
end
