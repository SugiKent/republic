# 授業系のページで必要なメソッドなど

class ClassesController < SessionsController
  def sidebar_ranking
    # 全カリの授業で、レビューにコメントがある授業。rep_3の大きさ順
    @ranking_lessons = Lesson.slider_module_includes.desc_lots_of_result.get_by_faculty(11).limit(3).distinct

    if current_user.present?
      @faculty_ranking_lessons = Lesson.slider_module_includes.desc_lots_of_result.get_by_faculty(current_user.faculty_id).limit(3).distinct
    end
  end

  def sidebar_features
    @sidebar_features = Feature.published.all
  end

  def set_favos
    # current_userが持つFavoriteオブジェクトたちを@favosに格納
    @favos = current_user.try(:favorites)
  end

  def current_user_count_result
    # Ajaxの場合実行しない
    return false if request.xhr?

    return false if current_user.nil? || current_user.first_grade?
    @result_count = current_user.results.count
  end

  def set_sidebar_elems
    # Ajaxの場合実行しない
    return false if request.xhr?

    sidebar_ranking
    sidebar_features
  end

  def set_result_ids
    ids = @lessons.pluck(:same_lessons).map{|i| i.split(',') }.flatten.uniq
    @result_ids = Result.where(lesson_id: ids).pluck(:lesson_id)
  end

end
