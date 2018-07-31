class AddColumnToDepartment < ActiveRecord::Migration
  def change
    add_column :departments, :published, :boolean, default: false, null: false
  end
end
