class User < ApplicationRecord

  has_secure_token

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :timeoutable
  belongs_to :faculty, optional: true
  belongs_to :department, optional: true
  has_many :results

  has_many :favorites, dependent: :destroy
  has_many :lessons, through: :favorites

  has_many :having_book_requests, class_name: 'BookRequest', foreign_key: :having_user_id, dependent: :destroy
  has_many :wanted_book_requests, class_name: 'BookRequest', foreign_key: :request_user_id, dependent: :destroy

  has_many :having_users, class_name: 'MatchedUser', foreign_key: :having_user_id, dependent: :destroy
  has_many :request_users, class_name: 'MatchedUser', foreign_key: :request_user_id, dependent: :destroy

  has_many :messages, dependent: :destroy
  has_many :chat_rooms, dependent: :nullify
  has_many :posts, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[0-9]{2}[a-z]{2}[0-9]{3}[a-z]{1}@rikkyo.ac.jp\Z/
  validates :email, format: { with: VALID_EMAIL_REGEX }

  # 昨日登録された User を取得
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  # 今日のログイン数
  scope :log_in_today, -> { where(updated_at: Time.zone.now.all_day) }
  # 昨日のログイン数
  scope :log_in_yesterday, -> { where(updated_at: 1.day.ago.all_day) }

  # ADMIN権限のユーザーメルアド
  ADMIN = ['14xx999z@rikkyo.ac.jp', '15xx999h@rikkyo.ac.jp'].freeze
  # パートナー権限（手伝ってくれるメンバー）のメルアド
  PARTNERS = ['16xx999h@rikkyo.ac.jp', '17xx999k@rikkyo.ac.jp'].freeze

  # ユーザー新規登録時に、学部と学科を紐づける
  after_create do
    # メールアドレスからdeparmentを取得
    department = Department.find_by(code: email.match(/^\d{2}([a-z]{2})/)[1])
    return false if department.blank?

    faculty = department.faculty
    self.department_id = department.id
    self.faculty_id = faculty.id
    save
  end

  def first_grade?
    # 1年生以外かどうか
    return false if nil?
    this_year = Time.now.year.to_s.match(/\d{2}$/)
    current_user_year = email.match(/^\d{2}/)

    # 今の年とユーザーの学年が一致する場合はtrueを返す
    this_year[0] == current_user_year[0]
  end

  def partner?
    PARTNERS.include?(email)
  end

  def admin?
    ADMIN.include?(email)
  end
end
