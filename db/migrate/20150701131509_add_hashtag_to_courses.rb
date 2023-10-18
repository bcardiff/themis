class AddHashtagToCourses < ActiveRecord::Migration[7.0]
  def change
    add_column :courses, :hashtag, :string
  end
end
