class LessonSchedule < ApplicationRecord
  belongs_to :lesson, optional: true
end
