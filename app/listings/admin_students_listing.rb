class AdminStudentsListing < Listings::Base
  model Student

  column :card_code, searchable: true
  column :first_name, searchable: true
  column :last_name, searchable: true
  column :email, searchable: true do |student|
    mail_to student.email
  end
  column :known_by

  column :created_at do |student|
    student.created_at.to_date
  end
  column '' do |student|
    "#{link_to('ver', admin_student_path(student))} #{link_to('editar', edit_admin_student_path(student))}"
  end

  export :csv, :xls
end
