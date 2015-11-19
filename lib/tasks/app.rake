namespace :app do
  def process_month_payments(month_number)
    date = Date.new(2015,month_number,01)
    month_range = date..date.at_end_of_month

    TeacherCashIncomes::StudentPaymentIncome.pack_payment.where(date: month_range).each do |payment|
      StudentPack.recalculate(payment)
    end

    StudentCourseLog.joins(course_log: :course).missing_payment.between(month_range).each do |student_course_log|
      student_course_log.assign_to_pack_if_no_payment
    end
  end

  def set_plan_price(code, price)
    PaymentPlan.find_by(code: code).tap do |plan|
      plan.price = price
      plan.save!
    end
  end

  desc "Build student_packs"
  task build_packs: :environment do
    single_class = PaymentPlan.find_by(code: PaymentPlan::SINGLE_CLASS)
    StudentCourseLog.where(payment_plan_id: single_class.id).update_all(requires_student_pack: false)

    set_plan_price "2_X_SEMANA", 350
    process_month_payments 6
    set_plan_price "2_X_SEMANA", 400
    process_month_payments 7
    process_month_payments 8
    process_month_payments 9
    process_month_payments 10
    process_month_payments 11
  end

  desc "Reset all passwords"
  task reset_pwd: :environment do
    user = User.find_by(email: ENV["USER"])
    user.password = ENV["PASSWORD"]
    user.password_confirmation = ENV["PASSWORD"]
    user.save!
  end

end
