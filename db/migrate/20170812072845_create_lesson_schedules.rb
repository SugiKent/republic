class CreateLessonSchedules < ActiveRecord::Migration
  def change
    create_table :lesson_schedules do |t|
      t.references :lesson, index: true, foreign_key: true
      t.integer :number
      t.text :content

      t.timestamps null: false
    end
  end
end
