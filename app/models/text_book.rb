class TextBook < ApplicationRecord
  has_many :text_book_lessons, dependent: :destroy
  has_many :lessons, through: :text_book_lessons
  has_many :book_requests
  has_many :book_stores

  scope :get_by_title, ->(title) { where('title like ?', "%#{title}%") }
  scope :get_by_author, ->(author) { where('author like ?', "%#{author}%") }
  scope :get_by_publisher, ->(publisher) { where('publisher like ?', "%#{publisher}%") }
  scope :get_by_published_year, ->(published_year) { where('published_year like ?', "%#{published_year}%") }
end
