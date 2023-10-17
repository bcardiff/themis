class AdminTeachersListing < Listings::Base
  model Teacher

  scope :active, 'Activos', default: true
  scope :all, 'Todos'

  column :name do |teacher|
    link_to teacher.name, admin_teacher_path(teacher)
  end

  column :card
  column :fee do |teacher|
    number_to_currency teacher.fee
  end

  column 'Efectivo en mano' do |teacher|
    link_to number_to_currency(teacher.owed_cash_total), owed_cash_admin_teacher_path(teacher)
  end

  column 'Salario adeudado' do |teacher|
    link_to number_to_currency(teacher.due_salary_total), due_course_salary_admin_teacher_path(teacher)
  end

  column 'Actividad mensual' do |teacher|
    link_to 'ver', month_activity_admin_teacher_path(teacher)
  end

  # column do |teacher|
  #   link_to 'clases', teach_log_admin_teacher_path(teacher)
  # end

  export :csv, :xls
end
