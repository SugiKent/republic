class MatchedUser < ApplicationRecord
  belongs_to :having_user, class_name: 'User', optional: true
  belongs_to :request_user, class_name: 'User', optional: true
  belongs_to :book_request, optional: true

  belongs_to :matchable, polymorphic: true, optional: true

  has_many :messages, as: :messageable
end
