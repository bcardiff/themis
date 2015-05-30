class AddValidUntilToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :valid_until, :date
  end
end
