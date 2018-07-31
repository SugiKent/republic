# ログイン状態に関するメソッド
# 全てのcontrollerが継承する

class SessionsController < ApplicationController
  # 通知をセットする
  before_action :set_notifications

  def sign_in_required
    if user_signed_in?
      false
    else
      flash[:warning] = 'ログインが必要です。'
      redirect_to new_user_session_url
    end
  end

  def sign_in_already
    redirect_to lesson_index_path if user_signed_in?
  end

  def logout_redirect
    redirect_to logout_path if user_signed_in?
  end
end
