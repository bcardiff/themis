class AddPlaceIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :place, index: true, foreign_key: true
  end
end
