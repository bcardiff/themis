class AddMissingToCourseLogs < ActiveRecord::Migration[7.0]
  def change
    add_column :course_logs, :missing, :boolean, null: false, default: false
  end
end
