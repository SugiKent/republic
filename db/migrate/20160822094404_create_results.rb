class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.string :grade
      t.integer :score
      t.references :lesson
      t.references :user

      t.timestamps null: false
    end
  end
end
