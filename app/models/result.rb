class Result < ApplicationRecord
  belongs_to :lesson, touch: true
  belongs_to :user, optional: true
  validates :score, :lesson_id, :user_id, :rep_1, :rep_2, :rep_3, presence: true
  validates :score, numericality: { less_than_or_equal_to: 4, greater_than_or_equal_to: 0 }
  validates :user_id,
            uniqueness: {
              message: 'すでにこの授業に評価を登録しています',
              scope: [:lesson_id]
            }

  # 昨日の登録数
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  # 今日の登録数
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }

  scope :user_faculty, ->(user) { where(lessons: { faculty_id: [user.faculty, 11] }) }
  scope :includes_faculty, -> { includes(lesson: :faculty) }
  scope :includes_department, -> { includes(lesson: :department) }
  scope :includes_fac_dep, -> { includes(:lesson).includes_faculty.includes_department }
end
