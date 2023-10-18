class AddPriorityToTeachers < ActiveRecord::Migration[7.0]
  def change
    add_column :teachers, :priority, :integer
  end
end
