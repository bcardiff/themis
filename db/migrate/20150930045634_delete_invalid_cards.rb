class DeleteInvalidCards < ActiveRecord::Migration[7.0]
  def up
    execute "DELETE FROM cards WHERE code IS NULL"
  end
end
