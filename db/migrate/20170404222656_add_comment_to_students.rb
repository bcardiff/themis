class AddCommentToStudents < ActiveRecord::Migration[7.0]
  def change
    add_column :students, :comment, :text
  end
end
