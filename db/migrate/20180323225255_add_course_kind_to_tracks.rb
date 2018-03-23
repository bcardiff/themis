class AddCourseKindToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :course_kind, :string
  end
end
