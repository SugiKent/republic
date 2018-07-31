class BookStore < ApplicationRecord
  belongs_to :text_book, optional: true
end
