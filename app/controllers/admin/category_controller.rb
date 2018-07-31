class Admin::CategoryController < AdminController
  before_action :set_category, only: %i[show edit update destroy]
  before_action :require_admin, except: [:index]

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    respond_to do |format|
      if @category.save
        format.html { redirect_to admin_category_index_path, notice: 'category was successfully created.' }
        format.json { render action: 'show', status: :created, location: @category }
      else
        format.html { render action: 'new' }
        format.json { render json: admin_category_index_path.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    # @path = admin_category_index_path
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to admin_category_index_path, notice: '授業情報をアップデートしました！' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to admin_category_index_url }
      format.json { head :no_content }
    end
  end

  def toggle_published
    @category = Category.find(params[:category_id])

    @category.toggle!(:published)
    if @category.published
      redirect_to admin_category_index_path, notice: 'カテゴリーを公開しました。'
    else
      redirect_to admin_category_index_path, notice: 'カテゴリーを非公開にしました。'
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
