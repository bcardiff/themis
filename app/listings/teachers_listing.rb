class TeachersListing < Listings::Base
  model Teacher

  column :name
  column :card
  column 'Pagos de alumnos' do |teacher|
    teacher.classes_money_owed
  end

  # column do |teacher|
  #   link_to 'clases', teach_log_admin_teacher_path(teacher)
  # end

  export :csv, :xls

end
