class AddMissingToCourseLogs < ActiveRecord::Migration
  def change
    add_column :course_logs, :missing, :boolean, null: false, default: false
  end
end
