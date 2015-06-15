class AddPlaceToCourses < ActiveRecord::Migration
  def change
    add_reference :courses, :place, index: true, foreign_key: true
  end
end
