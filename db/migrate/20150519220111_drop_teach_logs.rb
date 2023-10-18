class DropTeachLogs < ActiveRecord::Migration[7.0]
  def up
    drop_table :teach_logs
  end
end
