class AddWeekdayAndValidSinceToCourses < ActiveRecord::Migration[7.0]
  def change
    add_column :courses, :weekday, :integer
    add_column :courses, :valid_since, :date
  end
end
