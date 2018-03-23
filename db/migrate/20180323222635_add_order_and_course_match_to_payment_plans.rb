class AddOrderAndCourseMatchToPaymentPlans < ActiveRecord::Migration
  def change
    add_column :payment_plans, :order, :integer
    add_column :payment_plans, :course_match, :string
  end
end
