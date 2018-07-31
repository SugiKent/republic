class Classes::LessonController < ClassesController
  before_action :set_sidebar_elems, :current_user_count_result
  before_action :set_favos, only: %i[index search show]
  before_action :store_lesson_history, only: [:show]
  after_action :store_search_history, only: [:search]

  def index
    results = Result.all.order('created_at DESC').limit(30).pluck(:lesson_id).uniq
    @lessons = Lesson.slider_module_includes.where(id: results).order('results.created_at DESC').page(params[:page]).per(21)

    # ユーザーがログインしている場合、そのユーザーの学部の授業と全カリを表示
    @lessons = @lessons.get_by_faculty(current_user.faculty).or(@lessons.get_by_faculty(11)) if current_user.present?

    set_result_ids

    if current_user.present?
      if current_user.sign_in_count == 1
        @fl = 'fl'
        current_user.update(sign_in_count: 2)
      end
    end
  end

  def search
    @lessons = Lesson.lesson_module_includes.order(:lesson_name).all
    # 授業名と教授名をまとめて検索
    if params[:name].present?
      # 1文字以上の空白文字で区切る
      params[:name].split(/[[:blank:]]+/).each do |name|
        remove_word = name.match(/^[-ー](.+)/)
        @lessons = if remove_word.present?
                     @lessons.remove_word(remove_word[1], 'lesson_name').remove_word(remove_word[1], 'professor_name')
                   else
                     @lessons.get_by_name(name).or(@lessons.get_by_proname(name))
                   end
      end
    end

    # 教授名がGoogleにインデックスされているため、とっておく。
    if params[:professor_name].present?

      # nameのtext_fieldに値を入れるため
      params[:name] = params[:professor_name]

      params[:professor_name].split(/[[:blank:]]+/).each do |p_name|
        remove_word = p_name.match(/^[-ー](.+)/)
        @lessons = if remove_word.present?
                     @lessons.remove_word(remove_word[1], 'professor_name')
                   else
                     @lessons.get_by_proname p_name
                   end
      end
    end
    if params[:content].present?
      params[:content].split(/[[:blank:]]+/).each do |content|
        remove_word = content.match(/^[-ー](.+)/)
        @lessons = if remove_word.present?
                     @lessons.remove_word(remove_word[1], 'content')
                   else
                     @lessons.get_by_content content
                   end
      end
    end
    if params[:campus].present?
      @lessons = @lessons.get_by_campus params[:campus]
    end
    if params[:faculty_id].present?
      @lessons = @lessons.get_by_faculty params[:faculty_id]
    end
    if params[:department_id].present?
      @lessons = @lessons.get_by_department params[:department_id]
    end
    @lessons = @lessons.get_by_term params[:term] if params[:term].present?
    if params[:day].present? || params[:hour].present?
      @lessons = @lessons.get_by_period(params[:day]).get_by_period(params[:hour])
    end
    @lessons = @lessons.get_by_year(params[:year]) if params[:year].present?
    if params[:evaluation].present?
      @lessons = if params[:evaluation] != '0'
                   @lessons.get_by_evaluation params[:evaluation]
                 else
                   # 筆記試験のない授業
                   @lessons.none_writing
                 end
    end
    if params[:have_result]
      # same_lessons含めてResultのある授業を取得
      @lessons = Lesson.same_lessons_with_results(@lessons)
    end

    flash.now[:success] = "検索の結果#{@lessons.count}件見つかりました！"
    @lessons = @lessons.page(params[:page]).per(21)

    set_result_ids

    respond_to do |format|
      format.html
      format.json
      @has_amp = true
      # AMP対応用
      format.amp do
        @amp_ready = true
        lookup_context.formats = [:amp, :html] # .htmlのテンプレートも検索する
        render
      end
    end
  end

  def departments_select
    if request.xhr?
      render partial: 'departments', locals: { faculty_id: params[:faculty_id] }
    end
  end

  def first_login
    @user_mail = current_user.email
    @result_count = Result.all.count
    if request.xhr?
      render partial: 'first_login', locals: { user_mail: @user_mail, result_count: @result_count }
    end
  end

  def show
    @lesson = Lesson.find(params[:id])
    @current_year_lesson = Lesson.same_lesson(@lesson).current_year.not_it_self(@lesson)
    @results = Result.where(lesson_id: @lesson.same_lessons.split(','))
    # レビューを持つか、1年生ならtrue
    @has_result_and_first_grade = current_user.try(:results).present? || current_user.try(:first_grade?)

    # 関連授業
    # 現在表示している授業と学科・キャンパス・学期が同じもの
    @relative_lessons = Lesson.slider_module_includes.get_relative_lessons(@lesson)

    # レビューを書いたユーザーが書いた他のレビューの授業
    user_ids = @results.map(&:user_id)
    @user_relative_lessons = Lesson.slider_module_includes.where(results: { user_id: user_ids }).not_it_self(@lesson).limit(25)

    # 閲覧した授業
    @lesson_history = Lesson.visited_lessons(session[:lesson_history], @lesson)

    # 同じタグの付けられた授業
    if @lesson.tag.present?
      @tagged_lessons = Lesson.slider_module_includes.tagged_lessons(@lesson).not_it_self(@lesson).order('RAND()').limit(20)
    end

    respond_to do |format|
      format.html
      format.json

      @has_amp = true
      # AMP対応用
      format.amp do
        @amp_ready = true
        lookup_context.formats = [:amp, :html] # .htmlのテンプレートも検索する
        render
      end
    end
  end

  # Lessonとその子テーブルなどを全面的に取得できるjson api
  # 貴重なデータ&&若干サーバーへの負荷が大きいため一般には公開しない
  def ml_api
    return raise if params[:token] != Settings.api_token.ml_api && Rails.env.production?
    @lessons = Lesson.all_of_children.current_year.page(params[:page]).per(150)

    respond_to do |format|
      format.html
      format.json
    end
  end

  private

  # 検索履歴をsessionに追加していきます。
  def store_search_history
    # Ajaxなら早期return
    return false if request.xhr?

    # sessionが4kbを超えないようにするため
    session[:search_history] = if request.fullpath.to_s.size > 1200
                                 ''
                               else
                                 request.fullpath
                               end
  end

  # lesson#showを訪れた際、その授業IDを保存する
  def store_lesson_history
    return false if request.xhr?

    session[:lesson_history] = [] if session[:lesson_history].blank?

    # 過去に同じページを開いてる場合は早期return
    return false if session[:lesson_history].include?(params[:id])

    session[:lesson_history].shift if session[:lesson_history].size > 10
    session[:lesson_history] = session[:lesson_history] << params[:id]
  end

end
