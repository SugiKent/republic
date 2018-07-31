class Department < ApplicationRecord
  belongs_to :faculty, optional: true
  has_many :lessons
  has_many :users

  validates :faculty_id, presence: true
end
