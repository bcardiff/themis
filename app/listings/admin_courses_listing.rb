class AdminCoursesListing < Listings::Base
  model { Course.order(:code) }

  scope 'Todos', :all, default: true
  scope 'Vigentes', :ongoing, -> (model) {
    model.where(valid_until: nil)
  }

  column :code
  column :name
  column :valid_since
  column :valid_until

  export :xls, :csv

end
