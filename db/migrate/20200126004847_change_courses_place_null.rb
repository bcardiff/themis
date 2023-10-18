class ChangeCoursesPlaceNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :courses, :place_id, false
  end
end
