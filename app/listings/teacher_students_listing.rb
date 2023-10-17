class TeacherStudentsListing < Listings::Base
  model Student

  column :card_code, searchable: true
  column :first_name, searchable: true
  column :last_name, searchable: true

  column '' do |student|
    link_to 'ver', teacher_student_path(student)
  end
end
