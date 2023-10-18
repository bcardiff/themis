class AddCommentByToStudents < ActiveRecord::Migration[7.0]
  def change
    add_reference :students, :comment_by, references: :users
  end
end
