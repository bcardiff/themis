class AdminStudentActivitiesListing < Listings::Base
  model do
    Student.find(params[:id]).activity_logs.order(date: :desc)
  end

  column :date
  column :description
  column '' do |activity_log|
    case activity_log
    when ActivityLogs::Student::CourseAttended
      scl = activity_log.student_course_log
      if scl.as_helper
        raw '<span class="glyphicon glyphicon-education"></span>'
      elsif scl.missing_payment?
        raw '<span class="glyphicon glyphicon-warning-sign"></span>'
      end
    when ActivityLogs::Student::Payment
      if current_user.admin?
        link_to activity_log_admin_students_path(activity_log), method: :delete,
                                                                data: { confirm: 'Seguro desea borrar el registro de pago?' } do
          raw '<span class="glyphicon glyphicon-trash"></span>'
        end
      end
    end
  end
end
