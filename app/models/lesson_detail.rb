class LessonDetail < ApplicationRecord
  belongs_to :lesson, optional: true
end
