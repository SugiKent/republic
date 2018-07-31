class SlackNotifier
  # Slackのチャンネルに通知する
  # @pram message:表示するテキスト, channel:optional チャンネルのwebhook url
  def self.notify_to_slack(message, channel)
    notifier = Slack::Notifier.new(
      channel
    )
    notifier.ping(message)
  end
end
