class ChangeCoursesPlaceNull < ActiveRecord::Migration
  def change
    change_column_null :courses, :place_id, false
  end
end
