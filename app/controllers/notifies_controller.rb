class NotifiesController < SessionsController
  def create
    message = params[:message]
    email = current_user.try(:email)
    SlackNotifier.notify_to_slack("#{message}\n\n----\n\n#{email}\n\n----\n\n#{Time.now}", Settings.slack_webhook.contact)
    flash['info'] = "お問い合わせありがとうございます！\r\nこれからもRepをよろしくお願いします。"
    redirect_to request.referer
  end
end
