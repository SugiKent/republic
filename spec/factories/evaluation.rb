FactoryBot.define do
  factory :evaluation do
    kind '筆記試験(Written Exam)'
    percent 80
    content '筆記です'
  end

  factory :nil_evaluation, class: Evaluation do
    # 全てのカラムがnil
  end
end
