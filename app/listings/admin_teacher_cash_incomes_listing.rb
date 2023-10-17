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

  column :type, &:kind_description

  column 'Curso' do |income|
    income.course_log.try { |c| c.course.description(:short_track, :time) } if income.respond_to?(:course_log)
  end

  column 'Profesor' do |income|
    income.teacher.name
  end

  column :transferred_at do |income|
    income.transferred_at.try { |x| x.to_date.to_human }
  end

  column 'Alumno' do |income|
    income.student.display_name if income.respond_to?(:student)
  end

  column :payment_amount do |income|
    number_to_currency income.payment_amount
  end

  column :payment_status do |income|
    case income.payment_status
    when TeacherCashIncome::PAYMENT_ON_TEACHER
      'Profesor'
    when TeacherCashIncome::PAYMENT_ON_SCHOOL
      School.description
    else
      income.payment_status
    end
  end

  export :xls, :csv
end
