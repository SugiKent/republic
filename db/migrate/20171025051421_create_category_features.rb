class CreateCategoryFeatures < ActiveRecord::Migration
  def change
    create_table :category_features do |t|
      t.references :category, index: true, foreign_key: true
      t.references :feature, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
