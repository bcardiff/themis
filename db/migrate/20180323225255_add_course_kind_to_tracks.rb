class AddCourseKindToTracks < ActiveRecord::Migration[7.0]
  def change
    add_column :tracks, :course_kind, :string
  end
end
