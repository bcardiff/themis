class AddDeletedAtToPlaces < ActiveRecord::Migration[7.0]
  def change
    add_column :places, :deleted_at, :datetime
  end
end
