class FacultyFeature < ApplicationRecord
  belongs_to :faculty, optional: true
  belongs_to :feature, optional: true
end
