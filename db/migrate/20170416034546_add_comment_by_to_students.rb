class AddCommentByToStudents < ActiveRecord::Migration
  def change
    add_reference :students, :comment_by, references: :users
  end
end
