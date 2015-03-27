class CoursesListing < Listings::Base
  model Course

  column :code
  column :name

  export :xls, :csv

end
