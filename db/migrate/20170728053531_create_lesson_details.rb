class CreateLessonDetails < ActiveRecord::Migration
  def change
    create_table :lesson_details do |t|
      t.references :lesson, index: true, foreign_key: true
      t.text :code_title
      t.text :theme_subtitle
      t.text :professor
      t.string :term
      t.string :credit
      t.string :number
      t.string :language
      t.text :notes
      t.text :objectives
      t.text :content
      t.text :outside_study
      t.text :evaluation
      t.text :textbook
      t.text :reading
      t.text :others
      t.text :info

      t.timestamps null: false
    end
  end
end
