FactoryBot.define do
  factory :lesson_detail do
    code_title  '化学と自然(Chemistry and Nature)'
    theme_subtitle  '地球と人間生活における化学'
    professor  '森本　正和(MORIMOTO MASAKAZU)'
    term  '秋学期(Fall Semester)'
    credit  '２単位(2 Credits)'
    number  'CMP2500'
    language  '日本語(Japanese)'
    notes  '注意事項'
    objectives  '自然界で起こる現象や，生活の中で利用される物質・材料，環境・エネルギー問題などにおける化学の役割について学ぶ。自然を身近に感じながら地球と人間生活の未来について考えていくための知的基盤をつくる。'
    content  'まず，化学に関して考察する上で重要な原子構造・元素周期表・化学結合・化学反応などについて概説する。その後，大気をはじめとする地球環境，電池・プラスチック・光電子デバイスに用いられる身近な物質・材料，生命・健康に関わる生体関連物質などを題材として，地球や人間生活と化学との関係について講義する。'
    outside_study  '高等学校で学習した化学の教科書の内容をあらかじめ復習しておくとよい。¥n授業中に学習した内容を復習する。'
    evaluation  '評価基準は適当です'
    textbook  '授業中に資料を配布する。'
    reading  '必要に応じて授業中に紹介する。'
    others  '板書・プリント資料・視覚教材（スクリーン投影）を用いる。¥n提出物（課題など）について授業中に解説し，フィードバックを行う。'
    info  '備考です'
  end

  factory :nil_lesson_detail, class: LessonDetail do
    # 全てのカラムがnil
  end
end
