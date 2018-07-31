class Faculty < ApplicationRecord
  has_many :departments
  has_many :lessons
  has_many :faculty_features
  has_many :features, through: :faculty_features
  has_many :users
  has_many :chat_rooms, dependent: :destroy

  validates :faculty_name, presence: true, uniqueness: true

  scope :published_departments, -> { where(departments: { published: true }) }
end
