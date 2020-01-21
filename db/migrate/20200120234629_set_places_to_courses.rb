class SetPlacesToCourses < ActiveRecord::Migration
  class Place < ActiveRecord::Base
  end

  class Course < ActiveRecord::Base
    belongs_to :place
  end

  def up
    default_place = Place.where(name: School.description).first
    Course.where(place_id: nil).update_all(place_id: default_place.id)

    Place.where.not(id: default_place.id).update_all(deleted_at: Time.now.utc)
  end

  def down
  end
end
