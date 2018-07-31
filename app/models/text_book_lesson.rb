class TextBookLesson < ApplicationRecord
  belongs_to :text_book, optional: true
  belongs_to :lesson, optional: true

  enum book_type: %i[
    document
    textbook
  ]
end
