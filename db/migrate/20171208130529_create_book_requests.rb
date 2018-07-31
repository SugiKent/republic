class CreateBookRequests < ActiveRecord::Migration
  def change
    create_table :book_requests do |t|
      t.integer :having_user_id
      t.integer :request_user_id
      t.integer :requestable_id, null: false
      t.string :requestable_type, null: false

      t.timestamps null: false
    end
  end
end
