class Admin::ResultController < AdminController
  before_action :set_result, only: %i[show edit update destroy]
  before_action :require_admin, except: [:index]

  def index
    @results = Result.all.page(params[:page])
  end

  def edit
    # @path = admin_result_index_path
  end

  def update
    respond_to do |format|
      if @result.update(result_params)
        format.html { redirect_to @result, notice: 'レビューをアップデートしました！' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @result.destroy
    respond_to do |format|
      format.html { redirect_to admin_result_index_url }
      format.json { head :no_content }
    end
  end

  private

  def set_result
    @result = Result.find(params[:id])
  end

  def result_params
    params.require(:result).permit(:grade)
  end
end
