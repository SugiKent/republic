class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :title
      t.text :content
      t.boolean :published, default: false
      t.datetime :published_to

      t.timestamps null: false
    end
  end
end
