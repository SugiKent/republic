class Admin::FeatureController < AdminController
  before_action :set_feature, only: %i[show edit update destroy]
  before_action :require_admin, only: [:destroy]

  def index
    @features = Feature.all
  end

  def show
    # code
  end

  def new
    @feature = Feature.new
  end

  def create
    @feature = Feature.new(feature_params)
    respond_to do |format|
      if @feature.save
        format.html { redirect_to admin_feature_path(@feature), notice: '特集記事を作成しました！' }
        format.json { render action: 'show', status: :created, location: @feature }
      else
        format.html { render action: 'new' }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    # @path = admin_feature_index_path
  end

  def update
    respond_to do |format|
      if @feature.update(feature_params)
        format.html { redirect_to admin_feature_path(@feature), notice: '特集記事をアップデートしました！' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @feature.destroy
    respond_to do |format|
      format.html { redirect_to admin_feature_index_url }
      format.json { head :no_content }
    end
  end

  private

  def set_feature
    @feature = Feature.find(params[:id])
  end

  def feature_params
    params.require(:feature).permit(:title, :content, :published, :published_to, :image, :image_cache, :remove_image, { category_ids: [] }, faculty_ids: [])
  end
end
