class AdminStudentActivitiesListing < Listings::Base
  model {
    Student.find(params[:id]).activity_logs.order(date: :desc)
  }

  column :date
  column :description

end
