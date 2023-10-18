class AddStartTimeToCourses < ActiveRecord::Migration[7.0]
  def change
    add_column :courses, :start_time, :time
  end
end
