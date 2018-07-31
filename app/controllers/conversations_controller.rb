class ConversationsController < SessionsController
  before_action :basic_auth

  before_action :set_matched_user, only: %i[show]
  before_action :check_user, only: %i[show]

  def show
    @new_message = Message.new(user_id: current_user.try(:id), messageable_type: 'MatchedUser')
  end

  def create
    book_request = BookRequest.find(params[:book_request_id])
    error_msg = 'リクエストに失敗しました。'

    if book_request.having_user_id.present? && params[:having_user].to_i != current_user.id
      # current_userが本を持っている
      # かつ、そのparamsのhaving_userがログインユーザーでない時
      redirect_to :root, alert: error_msg
    elsif book_request.request_user_id.present? && params[:request_user].to_i != current_user.id
      # current_userが本を欲している
      # かつ、そのparamsのrequest_userがログインユーザーでない時
      redirect_to :root, alert: error_msg
    end

    @ship = MatchedUser.new(having_user_id: params[:having_user], request_user_id: params[:request_user], matchable_type: 'BookRequest', matchable_id: params[:book_request_id])

    if @ship.save
      flash[:info] = 'リクエストを送信しました！'
      redirect_to conversation_path(@ship)
    else
      redirect_to request.referrer, alert: error_msg
    end
  end

  private

  def set_matched_user
    @conversation = MatchedUser.find(params[:id])
  end

  def check_user
    if current_user != @conversation.having_user && current_user != @conversation.request_user
      error_msg = 'ログインが必要です。'
      redirect_to new_user_session_path, alert: error_msg
    end
  end
end
