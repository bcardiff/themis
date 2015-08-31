class AdminStudentActivitiesListing < Listings::Base
  model {
    Student.find(params[:id]).activity_logs.order(date: :desc)
  }

  column :date
  column :description
  column '' do |activity_log|
    case activity_log
    when ActivityLogs::Student::CourseAttended
      if activity_log.student_course_log.missing_payment?
        raw '<span class="glyphicon glyphicon-warning-sign"></span>'
      end
    end
  end

end
