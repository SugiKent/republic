class AddYearToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :year, :integer
  end
end
