class Admin::LessonController < AdminController
  before_action :set_lesson, only: %i[show edit update destroy]
  before_action :require_admin, only: %i[new create edit update destroy]

  def index
    @lessons = Lesson.all
  end

  def search
    @lessons = Lesson.order(:lesson_name).current_year.all
    if params[:lesson_name].present?
      @lessons = @lessons.get_by_name params[:lesson_name]
    end
    if params[:professor_name].present?
      @lessons = @lessons.get_by_proname params[:professor_name]
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
    flash.now[:success] = "検索の結果#{@lessons.count}件見つかりました！"
    @lessons = @lessons.page(params[:page])
  end

  def departments_select
    if request.xhr?
      render partial: 'departments', locals: { faculty_id: params[:faculty_id] }
    end
  end

  def new
    @lesson = Lesson.new
  end

  def create
    @lesson = Lesson.new(lesson_params)
    respond_to do |format|
      if @lesson.save
        format.html { redirect_to admin_lesson_index_path, notice: 'lesson was successfully created.' }
        format.json { render action: 'show', status: :created, location: @lesson }
      else
        format.html { render action: 'new' }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @lesson.update(update_lesson_params)
        format.html { redirect_to edit_admin_lesson_path(@lesson), notice: '授業情報をアップデートしました！' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @lesson.destroy
    respond_to do |format|
      format.html { redirect_to admin_lesson_index_path }
      format.json { head :no_content }
    end
  end

  private

  def set_lesson
    @lesson = Lesson.where(id: params[:id]).first
  end

  def lesson_params
    params.require(:lesson).permit(:lesson_name, :faculty_id, :department_id, :period, :term, :professor_name, :lesson_number, :lesson_code, :classroom, :note, :campus, :url, :year)
  end

  def update_lesson_params
    params.require(:lesson).permit(:lesson_name, :faculty_id, :department_id, :period, :term, :professor_name, :lesson_number, :lesson_code, :classroom, :note, :campus, :url, :year, lesson_detail_attributes: %i[id code_title theme_subtitle professor term credit number language notes objectives content outside_study evaluation textbook reading others info])
  end
end
