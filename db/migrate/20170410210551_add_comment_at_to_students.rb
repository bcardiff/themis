class AddCommentAtToStudents < ActiveRecord::Migration[7.0]
  def change
    add_column :students, :comment_at, :datetime
  end
end
