class AddLogToOnaSubmission < ActiveRecord::Migration[7.0]
  def change
    add_column :ona_submissions, :log, :text
  end
end
