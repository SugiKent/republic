class Lesson < ApplicationRecord
  TERMS = { '1' => '春学期', '2' => '秋学期', '3' => 'その他' }.freeze

  has_many :results
  belongs_to :faculty, optional: true
  belongs_to :department, optional: true
  has_many :favorites
  has_many :users, through: :favorites
  has_one :lesson_detail, dependent: :destroy
  accepts_nested_attributes_for :lesson_detail
  has_many :lesson_schedules, dependent: :destroy
  accepts_nested_attributes_for :lesson_schedules, allow_destroy: true
  has_many :text_book_lessons, dependent: :destroy
  has_many :text_books, through: :text_book_lessons, dependent: :destroy
  accepts_nested_attributes_for :text_books, allow_destroy: true
  has_many :evaluations, dependent: :destroy
  accepts_nested_attributes_for :evaluations, allow_destroy: true
  has_many :posts, dependent: :destroy
  belongs_to :topic, optional: true

  # 授業名による絞り込み
  scope :get_by_content, ->(content) { where('lesson_details.content like ?', "%#{content}%") }
  scope :get_by_name, ->(lesson_name) { where('lesson_name like ?', "%#{lesson_name}%") }
  # 担当講師名による絞り込み
  # replaceはmysqlの関数で、半角/全角のスペースを空文字にしている
  # 同様に受け取ったprofessor_nameもgsubで空白を削除
  scope :get_by_proname, ->(professor_name) { where("replace(replace(professor_name,' ',''),'　','' ) like ?", "%#{professor_name.gsub(/\s|　/, '')}%") }
  # キャンパスによる絞り込み
  scope :get_by_campus, ->(campus) { where(campus: campus) }
  # 学部名による絞り込み
  scope :get_by_faculty, ->(faculty_id) { where(faculty_id: faculty_id) }
  # 学科名による絞り込み
  scope :get_by_department, ->(department_id) { where(department_id: department_id) }
  # 学期による絞り込み
  scope :get_by_term, ->(term) { where(term: term) }
  # 曜日と時限による絞り込み
  # 引数はdayまたはhourで、LIKE検索をする
  scope :get_by_period, ->(period) { where('period like ?', "%#{period}%") }
  # 年度で絞り込み
  scope :get_by_year, ->(year) { where(year: year) }
  # 筆記の割合で絞り込み
  scope :get_by_evaluation, ->(percent) { joins(:evaluations).where('evaluations.kind like ?', '%筆記試験%').where('evaluations.percent <= ?', percent) }
  # 筆記試験のない授業を取得
  scope :none_writing, -> { joins(:evaluations).where.not('evaluations.kind like ?', '%筆記試験%') }

  # 現在の年の授業
  scope :current_year, -> { where(year: 2018) }

  # 不要なワードを除く
  # params
  # text: 除く単語
  # type: カラム名
  scope :remove_word, ->(text, type) { where.not("#{type} like ?", "%#{text}%") }

  # 同じ名前かつ、同じ教授かつ、同じ学部学科
  scope :same_lesson, ->(lesson) { where(lesson_name: lesson.lesson_name, professor_name: lesson.professor_name).get_by_faculty(lesson.faculty_id) }

  # 関連性のある授業を取得
  scope :relative_lessons, ->(lesson) { where(department_id: lesson.department_id, campus: lesson.campus, term: lesson.term) }

  # 自分自身を含まないlesson
  scope :not_it_self, ->(lesson) { where.not(id: lesson.id).distinct }

  scope :desc_lots_of_result, -> { joins(:results)}#.group('lesson_id').group('id').order('count(results.id) DESC') }

  # コメントある授業を取得
  scope :has_comment, -> { where.not(results: { comment: '' }) }

  # 同じタグの授業を取得
  scope :tagged_lessons, ->(lesson) { where(tag: lesson.tag, faculty_id: lesson.faculty_id, campus: lesson.campus).where.not(lesson_name: lesson.lesson_name) }

  scope :lesson_module_includes, -> { joins(:lesson_detail).includes(:evaluations).includes(:department).includes(:faculty).includes(:results) }
  scope :slider_module_includes, -> { preload(:evaluations).includes(:department).includes(:faculty).includes(:results) }
  scope :all_of_children, -> { includes(:lesson_detail).includes(:evaluations).includes(:department).includes(:faculty).includes(:results).includes(:text_books).includes(:lesson_schedules) }

  def has_results_include_past?
    Result.where(lesson_id: same_lessons.split(',')).count > 0
  end

  def self.get_relative_lessons(lesson)
    if lesson.blank?
      lesson = Lesson.get_by_faculty(11).joins(:results).has_comment.order('RAND()').last
    end
    # 関連授業
    # 現在表示している授業と学科・キャンパス・学期が同じもの
    relative_lessons(lesson).joins(:results).not_it_self(lesson).limit(12)
  end

  # 閲覧した授業を返します
  # orderで、与えた配列順に並び替えて返す
  def self.visited_lessons(lesson_history, it_self)
    return false if lesson_history.blank?
    slider_module_includes.where(id: lesson_history).not_it_self(it_self).order(["field(id, #{lesson_history.reverse.join(',')})"])
  end

  # same_lessonsを含めてレビューのある授業を取得
  # params
  # lessons: LessonのAR::Relations
  def self.same_lessons_with_results(lessons)
    ids = lessons.select { |l| l.same_lessons.split(',').size > 1 }.map(&:id).uniq
    Lesson.slider_module_includes.joins(:results).where(results: { lesson_id: ids })
  end
end
