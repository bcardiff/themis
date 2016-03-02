class AddDeletedAtToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :deleted_at, :datetime
  end
end
