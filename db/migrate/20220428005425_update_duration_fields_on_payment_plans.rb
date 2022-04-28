class UpdateDurationFieldsOnPaymentPlans < ActiveRecord::Migration
  def change
    change_column :payment_plans, :single_class, :boolean, :null => false
  end
end
