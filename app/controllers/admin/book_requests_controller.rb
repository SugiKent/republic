class Admin::BookRequestsController < AdminController
  before_action :require_admin

  def index
    @book_requests = BookRequest.all.page(params[:page])
  end

  def show
    # code
  end
end
