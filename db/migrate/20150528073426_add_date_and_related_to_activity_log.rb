class AddDateAndRelatedToActivityLog < ActiveRecord::Migration[7.0]
  def change
    add_column :activity_logs, :date, :date
    add_reference :activity_logs, :related, polymorphic: true, index: true
  end
end
