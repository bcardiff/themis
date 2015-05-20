class AddWeekdayAndValidSinceToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :weekday, :integer
    add_column :courses, :valid_since, :date
  end
end
