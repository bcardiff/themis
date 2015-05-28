class AdminStudentActivitiesListing < Listings::Base
  model {
    Student.find(params[:id]).activity_logs
  }

  column :date
  column :description

end
