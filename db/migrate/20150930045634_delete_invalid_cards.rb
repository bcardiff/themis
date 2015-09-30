class DeleteInvalidCards < ActiveRecord::Migration
  def up
    execute "DELETE FROM cards WHERE code IS NULL"
  end
end
