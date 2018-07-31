class CategoryFeature < ApplicationRecord
  belongs_to :category, optional: true
  belongs_to :feature, optional: true
end
