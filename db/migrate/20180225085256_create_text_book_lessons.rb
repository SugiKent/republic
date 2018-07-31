class CreateTextBookLessons < ActiveRecord::Migration
  def change
    create_table :text_book_lessons do |t|
      t.references :text_book, index: true, foreign_key: true, null: false
      t.references :lesson, index: true, foreign_key: true, null: false
      t.integer :type, null: false

      t.timestamps null: false
    end
  end
end
