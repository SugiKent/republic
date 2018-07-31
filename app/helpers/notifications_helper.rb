module NotificationsHelper
  # 通知欄の内容を生成する
  def notify_content(note)
    content = ''
    sabun_time = calc_sabun_time(note)

    case note.type
    when 'result'
      options = { type: note.type, path: lesson_path(note.id).to_s, icon: 'edit', title: '&nbsp;レビューが追加されました', name: "#{note.name}  ", help: note.content, sabun_time: sabun_time }

      content = set_content(options)
    when 'chat_room'
      options = { type: note.type, path: chat_room_path(note.id).to_s, icon: 'comment', title: '&nbsp;新しい掲示板ができました', name: note.name.to_s, sabun_time: sabun_time }

      content = set_content(options)
    end

    content.html_safe
  end

  # 通知が何分前のものかの文言を返します
  # params
  # note: ActivityLogのインスタンス
  def calc_sabun_time(note)
    day, sec_r = (Time.now - note.created_at).divmod(86_400)
    sabun_time = (Time.parse('1/1') + sec_r).strftime("#{day}日%-H時間%-M分")

    # 0日と0時間は削除
    sabun_time.gsub!(/0日|0時間|/, '')

    # 1日を超える場合は日にちだけ表示
    if day > 0
      sabun_time = "#{day}日"
    elsif sabun_time =~ /時間/
      # 0日以下、1時間以上の場合は時間だけ
      # 「4時間前」など
      sabun_time = (Time.parse('1/1') + sec_r).strftime('%-H時間')
    end

    sabun_time
  end

  def set_content(options = {})
    "<a href='#{options[:path]}' onClick='gtag('event', 'click', {'event_category': 'notification', 'event_label': '#{options[:type]}'});'><i class='glyphicon glyphicon-#{options[:icon]} Notify__icon'></i><span class='Notify__title'>#{options[:title]}</span><br>#{options[:name]}<span class='Notify__help'>#{options[:help]}</span><br><span class='Notify__time'>#{options[:sabun_time]}前</span></a>"
  end
end
