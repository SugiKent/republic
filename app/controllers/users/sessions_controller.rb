class Users::SessionsController < Devise::SessionsController
  after_action :flash_wo_kesuyo, only: [:destory]

  def create
    # メルアドでない場合、paramsにドメインを追加する
    domain = '@rikkyo.ac.jp'
    params[:user][:email] = params[:user][:email] + domain unless params[:user][:email].index(domain)
    @user = User.find_by(email: params[:user][:email])

    if @user.valid_password?(params[:user][:password])
      sign_in(@user)
      signed_in_url = session[:previous_url] || root_path
      flash[:info] = 'ログインしました'
      redirect_to signed_in_url
    else
      flash[:alert] = 'メールアドレスもしくはパスワードが正しくありません。'
      redirect_to new_user_session_path
    end
  end

  private

  def flash_wo_kesuyo
    flash.delete(:notice) if flash[:notice].present?
  end
end
