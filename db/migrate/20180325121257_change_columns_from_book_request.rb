class ChangeColumnsFromBookRequest < ActiveRecord::Migration
  def change
    drop_table :book_requests
    create_table :book_requests do |t|
      t.integer :having_user_id
      t.integer :request_user_id
      t.references :text_book, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
