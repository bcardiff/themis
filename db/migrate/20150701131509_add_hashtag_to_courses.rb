class AddHashtagToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :hashtag, :string
  end
end
