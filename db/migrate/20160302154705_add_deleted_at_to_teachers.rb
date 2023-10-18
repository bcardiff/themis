class AddDeletedAtToTeachers < ActiveRecord::Migration[7.0]
  def change
    add_column :teachers, :deleted_at, :datetime
  end
end
