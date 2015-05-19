class AddLogToOnaSubmission < ActiveRecord::Migration
  def change
    add_column :ona_submissions, :log, :text
  end
end
