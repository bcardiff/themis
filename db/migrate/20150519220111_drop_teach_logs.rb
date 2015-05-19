class DropTeachLogs < ActiveRecord::Migration
  def up
    drop_table :teach_logs
  end
end
