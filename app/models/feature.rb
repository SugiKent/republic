class Feature < ApplicationRecord
  has_many :faculty_features
  has_many :faculties, through: :faculty_features
  has_many :category_features
  has_many :categories, through: :category_features

  mount_uploader :image, ImageUploader
  scope :published, -> { where(published: true) }
end
