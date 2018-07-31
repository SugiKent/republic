class ChatRoom < ApplicationRecord
  belongs_to :user, optional: true
  has_many :posts, dependent: :destroy
  belongs_to :faculty, optional: true

  validates :title, presence: true

  scope :published, -> { where(published: true) }
end
