class AdminController < SessionsController
  before_action :sign_in_required
  before_action :require_permission
  before_action :login_notify

  private

  def require_permission
    # adminでもpartnerでもない時はrootへredirect
    unless current_user.partner? || current_user.admin?
      redirect_to admin_root_path, alert: 'ここから先は管理者限定です！'
    end
  end

  def require_admin
    unless current_user.admin?
      redirect_to admin_root_path, alert: '管理者じゃないとアカンよ〜'
    end
  end

  def login_notify
    return if current_user.admin?
    unless Rails.env.development?
      SlackNotifier.notify_to_slack("adminにアクションがありました。\n\n#{current_user.email}\n\n----\n\n#{request.path}##{request.request_method}\n\n#{request.ip}\n\n----\n\n#{Time.now}", Settings.slack_webhook.admin)
    end
  end
end
