FactoryBot.define do
  factory :lesson_schedule do
    number 1
    content 'はじめに，原子の構造と元素周期表'
  end

  factory :nil_lesson_schedule, class: LessonSchedule do
    # 全てのカラムがnil
  end
end
