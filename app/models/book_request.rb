class BookRequest < ApplicationRecord
  belongs_to :having_user, class_name: 'User', optional: true
  belongs_to :request_user, class_name: 'User', optional: true
  has_many :matched_users, as: :matchable
  belongs_to :text_book, optional: true

  validates :having_user_id, uniqueness: { scope: :text_book_id }, allow_nil: true
  validates :request_user_id, uniqueness: { scope: :text_book_id }, allow_nil: true

  def user
    if having_user
      having_user
    else
      request_user
    end
  end
end
