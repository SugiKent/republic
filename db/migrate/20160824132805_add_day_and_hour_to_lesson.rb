class AddDayAndHourToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :day, :integer
    add_column :lessons, :hour, :integer
  end
end
