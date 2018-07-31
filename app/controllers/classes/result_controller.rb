class Classes::ResultController < ClassesController
  before_action :sign_in_required
  before_action :set_result, only: %i[edit update destroy]

  def index
    @results = current_user.results.includes(:lesson).all

    # current_userが持つFavoriteオブジェクトたちを@favosに格納
    @spring_lessons = Lesson.where(term: [1, 3, 4]).includes(:favorites).where(favorites: { user_id: current_user }).includes(:department).includes(:faculty)

    @fall_lessons = Lesson.where(term: [2, 3, 4]).includes(:favorites).where(favorites: { user_id: current_user }).includes(:department).includes(:faculty)
  end

  def new
    @lesson = Lesson.find(params[:lesson_id])
    @result = @lesson.results.build
  end

  def create
    @lesson = Lesson.find(params[:lesson_id])
    @result = @lesson.results.build(result_params)
    @result.user_id = current_user.id

    scores = {'S'=>4, 'A'=>3, 'B'=>2, 'C'=>1, 'D'=>0}
    @result.score = scores[result_params[:grade]]

    respond_to do |format|
      if @result.save
        format.html { redirect_to lesson_path(@lesson) }
        flash[:success] = 'レビューありがとうございます！'

        if Rails.env.production?
          SlackNotifier.notify_to_slack("レビューが追加されたよー\n\n---\n\nhttp://www.rep-rikkyo.com/lesson/#{@lesson.id}\n\n----\n\n#{@result.comment}\n\n----\n\n#{@result.created_at}", Settings.slack_webhook.added_review)
        end

        format.json { render action: 'show', status: :created, location: @result }
      else
        format.html { render action: 'new' }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      update_param = result_params
      scores = {'S'=>4, 'A'=>3, 'B'=>2, 'C'=>1, 'D'=>0}
      update_param[:score] = scores[update_param[:grade]]

      if @result.update(update_param)
        flash[:success] = '授業のレビュー内容を更新しました！'
        format.html { redirect_to lesson_result_index_path }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @result.destroy
      respond_to do |format|
        flash[:danger] = 'レビューを削除しました！'
        format.html { redirect_to lesson_result_index_path }
        format.json { head :no_content }
      end
    end
  end

  private

  def set_result
    @lesson = Lesson.find(params[:lesson_id])
    @result = @lesson.results.find(params[:id])
  end

  def result_params
    params.require(:result).permit(:grade, :rep_1, :rep_2, :rep_3, :comment)
  end
end
