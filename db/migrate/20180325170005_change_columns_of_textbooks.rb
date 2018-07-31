class ChangeColumnsOfTextbooks < ActiveRecord::Migration
  def change
    remove_reference :text_books, :lesson, index: true, foreign_key: true
    change_column :text_books, :title, :text
    rename_column :text_book_lessons, :type, :book_type
  end
end
