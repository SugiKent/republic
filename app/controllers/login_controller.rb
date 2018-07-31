class LoginController < ApplicationController
  def login
    login_user = User.find_by(email: params[:email])

    if login_user.present? && login_user.valid_password?(params[:password])
      render plain: login_user.token
    else
      render plain: 'no auth'
    end
  end
end