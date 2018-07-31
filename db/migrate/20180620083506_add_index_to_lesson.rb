class AddIndexToLesson < ActiveRecord::Migration
  def change
    add_index :lessons, :lesson_name
    add_index :lessons, :professor_name
    add_index :lessons, :period
    add_index :lessons, :same_lessons
  end
end
