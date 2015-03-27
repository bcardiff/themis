class CreateOnaSubmissions < ActiveRecord::Migration
  def change
    create_table :ona_submissions do |t|
      t.string :form
      t.text :data
      t.string :status

      t.timestamps null: false
    end
  end
end
