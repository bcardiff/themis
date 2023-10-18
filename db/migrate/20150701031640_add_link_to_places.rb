class AddLinkToPlaces < ActiveRecord::Migration[7.0]
  def change
    add_column :places, :link, :string
  end
end
