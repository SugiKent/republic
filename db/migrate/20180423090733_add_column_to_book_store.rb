class AddColumnToBookStore < ActiveRecord::Migration
  def change
    add_column :book_stores, :is_sold, :boolean
  end
end
