class AddColorToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :color, :string
  end
end
