class AddReadedAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :readed_at, :datetime
  end
end
