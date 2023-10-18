class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.string :code
      t.references :student, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
