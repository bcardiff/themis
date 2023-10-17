class AdminFlowStatsDropsDetailsListing < Listings::Base
  model do
    student_course_logs = StudentCourseLog.all
      .where('EXTRACT(YEAR_MONTH FROM created_at) = ?', params[:period])
      .where('created_at = (SELECT MAX(t.created_at) FROM student_course_logs as t WHERE t.student_id = student_course_logs.student_id)')

    student_course_logs = student_course_logs.select(:student_id)

    Student.where("id in (#{student_course_logs.to_sql})")
  end

  column :card_code, searchable: true
  column :first_name, searchable: true
  column :last_name, searchable: true
  column :email, searchable: true do |student|
    if format == :html
      mail_to student.email
    else
      student.email
    end
  end

  column '' do |student|
    link_to('ver', admin_student_path(student))
  end

  export :csv, :xls
end
