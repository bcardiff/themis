class AddCommentAtToStudents < ActiveRecord::Migration
  def change
    add_column :students, :comment_at, :datetime
  end
end
