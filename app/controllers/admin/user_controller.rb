class Admin::UserController < AdminController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :require_admin

  def index
    @users = User.all.page(params[:page])
  end

  def show
    # code
  end

  def edit
    # @path = admin_user_index_path
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'レビューをアップデートしました！' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_user_index_url }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:grade)
  end
end
