class AddColumnToLesson < ActiveRecord::Migration
  def change
    add_reference :lessons, :faculty, index: true, foreign_key: true
    add_reference :lessons, :department, index: true, foreign_key: true
  end
end
