class Classes::FeatureController < ClassesController
  before_action :set_feature, only: [:show]
  before_action :set_sidebar_elems

  def show
    # ログインユーザーがadminかつpartnerではない時、公開状態ではない時にリダイレクト
    if current_user.present?
      if !current_user.admin? && !current_user.partner?
        if @feature.published == false
          redirect_to lesson_index_path, notice: 'この特集は現在非公開です。'
        end
      end
    end
    lesson = if @feature.faculties.present?
               Lesson.get_by_faculty(@feature.faculties.last).joins(:results).has_comment.last
    end
    # 関連授業
    # 学科・キャンパス・学期が同じもの
    @lessons = Lesson.get_relative_lessons(lesson).limit(3)

    set_result_ids
  end

  private

  def set_feature
    @feature = Feature.find(params[:id])
  end
end
