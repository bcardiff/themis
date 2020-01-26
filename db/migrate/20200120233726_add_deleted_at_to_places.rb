class AddDeletedAtToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :deleted_at, :datetime
  end
end
