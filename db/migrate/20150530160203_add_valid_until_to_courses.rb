class AddValidUntilToCourses < ActiveRecord::Migration[7.0]
  def change
    add_column :courses, :valid_until, :date
  end
end
