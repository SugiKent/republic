class Classes::FavoritesController < ClassesController
  before_action :sign_in_required, only: :none

  def create
    # create.jsにFavoriteとLessonのオブジェクトを渡す
    @user_id = current_user.id
    @lesson = Lesson.find(params[:id])
    @favorite = Favorite.new(lesson_id: @lesson.id, user_id: @user_id)

    @favorite.save
  end

  def destroy
    # destroy.jsにLessonのオブジェクトを渡す
    @favorite = Favorite.find(params[:id])
    @lesson = Lesson.find(@favorite.lesson_id)
    if @favorite.user_id != current_user.id
      return redirect_to root_path
    else
      @favorite.destroy
    end
  end

  def none
    # サインアップ画面への遷移用
  end
end
