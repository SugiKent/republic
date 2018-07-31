class Users::RegistrationsController < Devise::RegistrationsController
  layout 'users', only: %i[new create]

  # 通知をセットする
  before_action :set_notifications

  def create
    # メルアドでない場合、paramsにドメインを追加する
    domain = '@rikkyo.ac.jp'
    params[:user][:email] = params[:user][:email] + domain unless params[:user][:email].index(domain)
    @user = User.find_by(email: params[:user][:email])

    if @user.present?
      flash[:info] = "すでに登録済みです"
      redirect_to new_user_session_path
    else
      @user = User.new(user_params)
      @user.save!

      signed_in_url = session[:previous_url] || root_path
      flash[:success] = '本人確認メールを送信しました。立教メールをご確認ください。'
      redirect_to signed_in_url
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
