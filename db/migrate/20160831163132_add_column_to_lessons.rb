class AddColumnToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :lesson_number, :string
    add_column :lessons, :lesson_code, :string
    add_column :lessons, :professor_name, :string
    add_column :lessons, :term, :integer
    add_column :lessons, :classroom, :string
    add_column :lessons, :note, :text
  end
end
