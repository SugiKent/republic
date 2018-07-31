class Admin::PostsController < AdminController
  before_action :set_posts, only: [:destroy]
  before_action :require_admin, except: %i[index show]

  def index
    @posts = Post.all.page(params[:page])
  end

  def show
    @lesson = Lesson.find(params[:id])
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to admin_posts_url }
      format.json { head :no_content }
    end
  end

  private

  def set_posts
    @post = Post.find(params[:id])
  end
end
