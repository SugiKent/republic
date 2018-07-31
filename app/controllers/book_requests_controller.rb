class BookRequestsController < SessionsController
  before_action :basic_auth

  def show
    @book_request = BookRequest.find(params[:id])

    # この本のリクエストとマッチしているリクエストを返す
    @matched_requests = BookRequest.where(text_book_id: @book_request.text_book_id)

    if @book_request.having_user_id.present?
      # request_user_idとhaving_user_idで、互いに片方がnilのレコードを探す

      # current_userが本を持っている時
      @matched_requests = @matched_requests.where.not(request_user_id: nil)
      @matched_users = MatchedUser.where(matchable_id: @book_request)
    else
      # current_userが本を欲している時
      @matched_requests = @matched_requests.where.not(having_user_id: nil)
      @matched_users = MatchedUser.where(matchable_id: @book_request)
    end
  end
end
