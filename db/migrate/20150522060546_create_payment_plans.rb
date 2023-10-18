class CreatePaymentPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_plans do |t|
      t.string :code
      t.string :description
      t.decimal :price

      t.timestamps null: false
    end
  end
end
