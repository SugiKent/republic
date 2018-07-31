class AddSameessonsToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :same_lessons, :string, index: true
  end
end
