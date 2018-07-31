class AddColumnsToTextbooks < ActiveRecord::Migration
  def change
    add_column :text_books, :amazon_isbn, :string
    add_column :text_books, :amazon_publisher, :string
    add_column :text_books, :published_date, :date
    add_column :text_books, :lowest_new_price, :integer
    add_column :text_books, :asin, :string

    change_column :text_books, :amazon_title, :text
    change_column :text_books, :amazon_page, :text
    change_column :text_books, :medium_image, :text
    change_column :text_books, :large_image, :text
  end
end
