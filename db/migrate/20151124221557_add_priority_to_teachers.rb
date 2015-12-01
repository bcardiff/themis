class AddPriorityToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :priority, :integer
  end
end
