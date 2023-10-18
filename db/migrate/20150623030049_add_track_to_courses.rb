class AddTrackToCourses < ActiveRecord::Migration[7.0]
  def change
    add_reference :courses, :track, index: true, foreign_key: true
  end
end
