class SetPlacesToCourses < ActiveRecord::Migration[7.0]
  class Place < ActiveRecord::Base
  end

  class Course < ActiveRecord::Base
    belongs_to :place
  end

  def up
    default_place = Place.where(name: School.description).first
    Course.where(place_id: nil).update_all(place_id: default_place.id) unless default_place.nil?

    Place.where.not(id: default_place.id).update_all(deleted_at: Time.now.utc) unless default_place.nil?
  end

  def down
  end
end
