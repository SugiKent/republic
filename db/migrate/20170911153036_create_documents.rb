class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :lesson, index: true, foreign_key: true
      t.string :author
      t.string :title
      t.string :publisher
      t.string :published_year
      t.string :isbn

      t.timestamps null: false
    end
  end
end
