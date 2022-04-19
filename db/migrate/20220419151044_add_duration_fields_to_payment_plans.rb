class AddDurationFieldsToPaymentPlans < ActiveRecord::Migration
  def change
    add_column :payment_plans, :single_class, :boolean
    add_column :payment_plans, :weeks, :integer
    add_column :payment_plans, :due_date_months, :integer

    add_column :payment_plans, :deleted_at, :datetime
  end
end
