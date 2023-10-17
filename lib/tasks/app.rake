namespace :app do
  def process_month_payments(month_number)
    date = Date.new(2015, month_number, 0o1)
    month_range = date..date.at_end_of_month

    TeacherCashIncomes::StudentPaymentIncome.pack_payment.where(date: month_range).each do |payment|
      StudentPack.recalculate(payment)
    end

    StudentCourseLog.joins(course_log: :course).missing_payment.between(month_range).each(&:assign_to_pack_if_no_payment)
  end

  def set_plan_price(code, price)
    PaymentPlan.find_by(code: code).tap do |plan|
      plan.price = price
      plan.save!
    end
  end

  def add_pack(month_number, card_code, price)
    date = Date.new(2015, month_number, 0o1)
    student = Student.find_by_card(card_code)
    StudentPack.register_for(student, date, price)
  end

  def migration_packs
    add_pack(4, '217', 300)
    add_pack(4, '519', 350)
    add_pack(4, '601', 350)
    add_pack(4, '465', 350)
    add_pack(4, '464', 300)
    add_pack(4, '462', 300)
    add_pack(4, '278', 550)
    add_pack(4, '279', 550)
    add_pack(4, '262', 300)
    add_pack(4, '29', 250)
    add_pack(4, '28', 250)
    add_pack(4, '295', 250)
    add_pack(4, '293', 250)
    add_pack(4, '292', 250)
    add_pack(4, '289', 550)
    add_pack(4, '284', 550)
    add_pack(4, '441', 550)
    add_pack(4, '596', 250)
    add_pack(4, '175', 250)
    add_pack(4, '158', 250)
    add_pack(4, '102', 350)
    add_pack(4, '342', 250)
    add_pack(4, '384', 250)
    add_pack(4, '313', 250)
    add_pack(4, '344', 250)
    add_pack(4, '351', 550)
    add_pack(4, '348', 250)
    add_pack(4, '314', 550)
    add_pack(4, '316', 550)
    add_pack(4, '132', 250)
    add_pack(4, '131', 550)
    add_pack(4, '246', 250)
    add_pack(4, '363', 250)
    add_pack(4, '417', 250)
    add_pack(4, '261', 250)
    add_pack(4, '461', 300)
    add_pack(4, '317', 250)
    add_pack(4, '585', 250)
    add_pack(4, '551', 250)
    add_pack(4, '595', 250)
    add_pack(4, '223', 250)
    add_pack(4, '353', 250)
    add_pack(4, '352', 250)
    add_pack(4, '366', 250)
    add_pack(4, '275', 250)
    add_pack(4, '364', 250)
    add_pack(4, '312', 250)
    add_pack(4, '586', 250)
    add_pack(4, '584', 250)
    add_pack(4, '391', 550)
    add_pack(4, '81', 250)
    add_pack(4, '24', 250)
    add_pack(4, '458', 550)
    add_pack(4, '350', 550)
    add_pack(4, '132', 250)
    add_pack(4, '131', 550)
    add_pack(4, '246', 250)
    add_pack(4, '363', 250)
    add_pack(4, '416', 250)

    add_pack(5, '29', 250)
    add_pack(5, '292', 250)
    add_pack(5, '595', 250)
    add_pack(5, '335', 350)
    add_pack(5, '15', 550)
    add_pack(5, '138', 350)
    add_pack(5, '364', 250)
    add_pack(5, '312', 250)
    add_pack(5, '317', 250)
    add_pack(5, '507', 250)
    add_pack(5, '551', 250)
    add_pack(5, '362', 250)
    add_pack(5, '353', 250)
    add_pack(5, '352', 250)
    add_pack(5, '102', 350)
    add_pack(5, '2', 250)
    add_pack(5, '278', 250)
    add_pack(5, '279', 250)
    add_pack(5, '299', 250)
    add_pack(5, '13', 550)
    add_pack(5, '149', 350)
    add_pack(5, '87', 250)
    add_pack(5, '17', 250)
    add_pack(5, '150', 550)
    add_pack(5, '357', 250)
    add_pack(5, '366', 250)
    add_pack(5, '586', 250)
    add_pack(5, '223', 250)
    add_pack(5, '385', 350)
    add_pack(5, '253', 250)
    add_pack(5, '177', 350)
    add_pack(5, '374', 250)
    add_pack(5, '376', 250)
    add_pack(5, '375', 250)
    add_pack(5, '414', 300)
    add_pack(5, '28', 300)
    add_pack(5, '251', 250)
    add_pack(5, '465', 350)
    add_pack(5, '24', 250)
    add_pack(5, '415', 550)
    add_pack(5, '463', 250)
    add_pack(5, '514', 250)
    add_pack(5, '513', 250)
    add_pack(5, '464', 250)
    add_pack(5, '355', 250)
    add_pack(5, '358', 250)
    add_pack(5, '365', 250)
    add_pack(5, '465', 550)
    add_pack(5, '594', 250)
    add_pack(5, '313', 250)
    add_pack(5, '314', 550)
    add_pack(5, '457', 550)
    add_pack(5, '323', 350)
    add_pack(5, '032', 550)
    add_pack(5, '105', 350)
    add_pack(5, '343', 250)
    add_pack(5, '559', 300)
    add_pack(5, '548', 250)
    add_pack(5, '546', 250)
    add_pack(5, '208', 350)
    add_pack(5, '233', 350)
    add_pack(5, '153', 350)
    add_pack(5, '315', 250)
    add_pack(5, '329', 250)
    add_pack(5, '395', 350)
    add_pack(5, '132', 250)
    add_pack(5, '556', 350)
    add_pack(5, '120', 550)
    add_pack(5, '089', 550)
    add_pack(5, '022', 550)
    add_pack(5, '240', 350)
    add_pack(5, '099', 350)
    add_pack(5, '248', 250)
    add_pack(5, '271', 350)
    add_pack(5, '241', 550)
  end

  desc 'Build student_packs'
  task build_packs: :environment do
    single_class = PaymentPlan.find_by(code: PaymentPlan::SINGLE_CLASS)
    StudentCourseLog.where(payment_plan_id: single_class.id).update_all(requires_student_pack: false)

    set_plan_price '2_X_SEMANA', 350
    migration_packs
    process_month_payments 6
    set_plan_price '2_X_SEMANA', 400
    process_month_payments 7
    process_month_payments 8
    process_month_payments 9
    process_month_payments 10
    process_month_payments 11
  end

  desc 'Reset all passwords'
  task reset_pwd: :environment do
    user = User.find_by(email: ENV.fetch('USER', nil))
    user.password = ENV.fetch('PASSWORD', nil)
    user.password_confirmation = ENV.fetch('PASSWORD', nil)
    user.save!
  end
end
