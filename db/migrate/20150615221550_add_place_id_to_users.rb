class AddPlaceIdToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :place, index: true, foreign_key: true
  end
end
