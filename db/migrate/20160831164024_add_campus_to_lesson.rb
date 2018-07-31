class AddCampusToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :campus, :integer
  end
end
