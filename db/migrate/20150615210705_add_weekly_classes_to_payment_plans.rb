class AddWeeklyClassesToPaymentPlans < ActiveRecord::Migration
  def change
    add_column :payment_plans, :weekly_classes, :integer
  end
end
