class AdminTeacherCashIncomesListing < Listings::Base
  model do
    TeacherCashIncome.order('date desc')
    # StudentCourseLog.with_payment.joins(:course_log).order('course_logs.date desc')
  end

  scope 'Todos', :all, default: true
  scope 'En Profesor', :owed
  scope "Entregados a #{School.description}", :handed

  column :date do |income|
    income.date.to_human
  end

  column :type do |income|
    income.kind_description
  end

  column 'Curso' do |income|
    if income.respond_to?(:course_log)
      income.course_log.try(:name_with_wday_as_context)
    end
  end

  column 'Profesor' do |income|
    income.teacher.name
  end

  column :transferred_at do |income|
    income.transferred_at.try { |x| x.to_date.to_human }
  end

  column 'Alumno' do |income|
    if income.respond_to?(:student)
      income.student.display_name
    end
  end

  column :payment_amount do |income|
    number_to_currency income.payment_amount
  end

  column :payment_status do |income|
    case income.payment_status
    when TeacherCashIncome::PAYMENT_ON_TEACHER
      "Profesor"
    when TeacherCashIncome::PAYMENT_ON_SCHOOL
      School.description
    else
      income.payment_status
    end
  end

  export :xls, :csv

end
