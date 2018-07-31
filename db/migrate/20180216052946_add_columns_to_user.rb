class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_reference :users, :department, index: true, foreign_key: true
    add_reference :users, :faculty, index: true, foreign_key: true
  end
end
