class Category < ApplicationRecord
  has_many :category_features
  has_many :features, through: :category_features

  scope :published, -> { where(published: true) }
end
