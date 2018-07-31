module Class::LessonHelper
  require 'cgi'

  def lesson_period_format(period)
    return if period.blank?
    formated_period = ''
    day = { 'a' => '月', 'b' => '火', 'c' => '水', 'd' => '木', 'e' => '金', 'f' => '土' }
    period.split(',').each do |p|
      next if p.blank?
      formated_period += day[p[0].to_s]
      formated_period += '・'
      formated_period += p[2].to_s
      formated_period += '<br>'
    end
    formated_period.html_safe
  end

  def lesson_campus_format(campus)
    formated_campus =
      case campus
      when 1
        '池袋'
      when 2
        '新座'
      when 3
        'その他'
      end
    formated_campus
  end

  def lesson_term_format(term)
    formated_term =
      case term
      when 1
        '春'
      when 2
        '秋'
      when 3
        '通年'
      when 4
        'その他の'
      end
    formated_term
  end

  # 検索された条件を日本語にして返します。
  # 引数には検索した時のURLを。
  def lesson_search_condition(searched_url)
    words = ''

    # 検索パラメーターがないときはreturn
    return '' if searched_url == '/lesson/search'
    searched_url.split('&').each do |param|
      key = param.match(/(.+)=/)
      value = param.match(/=(.+)/)

      next if key.blank?

      # paramsのkeyがutf8とcommitとpageのとき、
      # または、valueがnilのときにnext
      next if key[1].include?('utf8') || key[1].include?('commit') || key[1].include?('page')
      next if value.nil?

      case key[1]
      when 'campus'
        words += lesson_campus_format(value[1].to_i) + 'キャンパス'
      when 'faculty_id'
        words += Faculty.find(value[1]).faculty_name
      when 'department_id'
        words += Department.find(value[1]).department_name
      when 'term'
        words += lesson_term_format(value[1].to_i) + '学期'
      when 'day'
        days = { 'a' => '月', 'b' => '火', 'c' => '水', 'd' => '木', 'e' => '金', 'f' => '土' }
        words += days[value[1]] + '曜日'
      when 'hour'
        words += value[1] + '限目'
      when 'have_result'
        words += 'レビューあり'
      when 'evaluation'
        words += "#{value[1]}%の筆記"
      else
        words += "「#{CGI.unescape(value[1])}」"
      end

      words += ' - '
    end
    "#{words}#{' の' unless words.blank?}"
  end

  def professor_name_link(professor_name)
    return '未定' if professor_name.blank?
    formated_name = ''
    professor_name.split(/\s/).each do |name|
      formated_name += "<a href='#{search_lesson_index_url(name: name)}'>" + name + '</a><br>'
    end
    formated_name
  end
end
