class TeachersListing < Listings::Base
  model Teacher

  column :name
  column :card

  column do |teacher|
    link_to 'clases', teach_log_teacher_path(teacher)
  end

  export :csv, :xls

end
