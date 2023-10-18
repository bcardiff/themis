class UpdateCaballitoName < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      UPDATE places SET name = 'La Fragua' WHERE name = 'Donarte'
    SQL
  end

  def down
    execute <<-SQL
      UPDATE places SET name = 'Donarte' WHERE name = 'La Fragua'
    SQL
  end
end
