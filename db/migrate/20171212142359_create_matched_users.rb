class CreateMatchedUsers < ActiveRecord::Migration
  def change
    create_table :matched_users do |t|
      t.integer :having_user_id, null: false
      t.integer :request_user_id, null: false
      t.integer :matchable_id, null: false
      t.string :matchable_type, null: false

      t.timestamps null: false
    end
  end
end
