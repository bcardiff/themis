class AdminStatsDetailsListing < Listings::Base

  model do
    student_course_logs = StudentCourseLog.joins(course_log: :course)
    if params[:wday].present?
      wday = params[:wday].to_i
      student_course_logs = student_course_logs.where(courses: {weekday: wday})
    end

    if params[:track_id]
      student_course_logs = student_course_logs.where(courses: {track_id: params[:track_id]})
    end

    student_course_logs = student_course_logs.select(:student_id)

    Student.where("id in (#{student_course_logs.to_sql})")
  end

  column :card_code, searchable: true
  column :first_name, searchable: true
  column :last_name, searchable: true
  column :email, searchable: true do |student|
    mail_to student.email
  end

  column '' do |student|
    link_to('ver', admin_student_path(student)) + ' ' + link_to('editar', edit_admin_student_path(student))
  end

  export :csv, :xls
end
