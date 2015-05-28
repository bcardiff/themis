class AddDateAndRelatedToActivityLog < ActiveRecord::Migration
  def change
    add_column :activity_logs, :date, :date
    add_reference :activity_logs, :related, polymorphic: true, index: true
  end
end
