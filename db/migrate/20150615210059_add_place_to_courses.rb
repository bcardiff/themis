class AddPlaceToCourses < ActiveRecord::Migration[7.0]
  def change
    add_reference :courses, :place, index: true, foreign_key: true
  end
end
