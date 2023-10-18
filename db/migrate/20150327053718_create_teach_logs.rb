class CreateTeachLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :teach_logs do |t|
      t.date :date
      t.references :teacher
      t.references :course

      t.timestamps null: false
    end
  end
end
