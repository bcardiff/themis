class BuildCardsFromStudents < ActiveRecord::Migration[7.0]
  def up
    execute "DELETE FROM cards"
    time = Time.now.to_s(:db)
    execute "INSERT INTO cards (code, student_id, created_at, updated_at) SELECT students.card_code, students.id, '#{time}', '#{time}' FROM students"
  end

  def down
  end
end
