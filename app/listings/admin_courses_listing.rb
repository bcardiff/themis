class AdminCoursesListing < Listings::Base
  include ApplicationHelper

  model { Course.order(:weekday, :start_time, :code) }

  scope 'Todos', :all, default: true
  scope 'Vigentes', :ongoing_or_future

  column :code
  column :name
  column :weekday do |c|
    local_wday(c.weekday)
  end
  column :start_time do |c|
    if c.start_time
      "#{c.start_time.hour}:#{"%02d" % c.start_time.min}"
    end
  end
  column :valid_since
  column :valid_until

  export :xls, :csv

end
