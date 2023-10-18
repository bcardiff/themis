class CreateActivityLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_logs do |t|
      t.string :type
      t.references :target, polymorphic: true, index: true
      t.text :description

      t.timestamps null: false
    end
  end
end
