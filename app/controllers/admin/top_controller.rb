class Admin::TopController < AdminController
  def index
    # 現在のレビュー数
    @results = Result.count
    # 現在のユーザー数
    @users = User.count
    # 今日のログイン数
    @user_login_today = User.log_in_today.count
    # 今日のレビュー登録数
    @result_today = Result.created_today.count
    # 昨日のログイン数
    @user_login_yesterday = User.log_in_yesterday.count
    # 昨日のユーザー登録数
    @user_yesterday = User.created_yesterday.count
    # 昨日のレビュー登録数
    @result_yesterday = Result.created_yesterday.count
  end

  private
end
