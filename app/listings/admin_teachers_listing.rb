class AdminTeachersListing < Listings::Base
  model Teacher

  column :name do |teacher|
    link_to teacher.name, admin_teacher_path(teacher)
  end

  column :card
  column :fee do |teacher|
    number_to_currency teacher.fee
  end

  column 'Pagos de alumnos' do |teacher|
    link_to number_to_currency(teacher.owed_student_payments), owed_student_payments_admin_teacher_path(teacher)
  end

  column 'Salario adeudado' do |teacher|
    link_to number_to_currency(teacher.due_salary), due_course_salary_admin_teacher_path(teacher)
  end

  # column do |teacher|
  #   link_to 'clases', teach_log_admin_teacher_path(teacher)
  # end

  export :csv, :xls

end
