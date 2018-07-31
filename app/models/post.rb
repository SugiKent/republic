class Post < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :chat_room, optional: true

  validates :content, presence: true
end
