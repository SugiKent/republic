class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :messageable_id
      t.string :messageable_type
      t.text :content

      t.timestamps null: false
    end
  end
end
