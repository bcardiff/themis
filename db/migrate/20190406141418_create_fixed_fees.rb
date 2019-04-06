class CreateFixedFees < ActiveRecord::Migration
  def change
    create_table :fixed_fees do |t|
      t.string :code
      t.string :name
      t.decimal :value

      t.timestamps null: false
    end
  end
end
