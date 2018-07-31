FactoryBot.define do
  factory :lesson do
    lesson_name 'テスト講義'
    to_create do |instance|
      instance.save validate: false
    end
    trait :with_result do
      after(:create) do |lesson|
        lesson.results = []
        lesson.results << FactoryBot.create(:result, lesson_id: lesson.id)
      end
    end
  end

  factory :zenkari_lesson, class: Lesson do
    lesson_name '全カリ講義'
    faculty_id 11
    department_id 33

    to_create do |instance|
      instance.save validate: false
    end
    trait :with_result do
      after(:create) do |lesson|
        lesson.results = []
        lesson.results << FactoryBot.create(:result, lesson_id: lesson.id)
      end
    end
  end

  factory :full_data_lesson, class: Lesson do
    lesson_name 'フルデータ授業'
    faculty_id 11
    department_id 33
    lesson_number 'CMP2500'
    lesson_code '多彩５/主総Ａ５'
    professor_name '森本　正和'
    term 2
    period 'a_1'
    classroom 'D201'
    note '特になし'
    campus 1
    url 'https://sy.rikkyo.ac.jp/timetable/slbssbdr.do?value(risyunen)=2018&value(semekikn)=1&value(kougicd)=FE114&value(crclumcd)='
    year 2018
    topic_id 34
    tag 259
    same_lessons '12373,13083'

    trait :with_lesson_detail do
      after(:create) do |lesson|
        lesson.lesson_detail = FactoryBot.create(:lesson_detail, lesson_id: lesson.id)
      end
    end

    trait :with_lesson_schedules do
      after(:create) do |lesson|
        lesson.lesson_schedules = []
        count = 1
        while count < 15
          lesson.lesson_schedules << FactoryBot.create(:lesson_schedule, {
            number: count,
            lesson_id: lesson.id
          })
          count += 1
        end
      end
    end

    trait :with_evaluations do
      after(:create) do |lesson|
        lesson.evaluations = []
        percent = 20
        while percent < 100
          lesson.evaluations << FactoryBot.create(:evaluation, {
            percent: percent,
            lesson_id: lesson.id
          })
          percent += 80
        end
      end
    end

    trait :with_textbooks do
      after(:create) do |lesson|
        lesson.text_book_lessons = []
        document = TextBook.first
        textbook = TextBook.last

        # Document
        lesson.text_book_lessons << FactoryBot.create(:text_book_lesson, {
          lesson_id: lesson.id,
          text_book_id: document.id,
          book_type: 0
        })

        # Textbook
        lesson.text_book_lessons << FactoryBot.create(:text_book_lesson, {
          lesson_id: lesson.id,
          text_book_id: textbook.id,
          book_type: 1
        })
      end
    end
  end

  # lesson#showに必要な最低限のデータが揃っている
  # same_lessonsがnilでなければ最低限のデータとなる
  factory :minimum_data_lesson, class: Lesson do
    same_lessons ''
    after(:create) do |lesson|
      lesson.lesson_detail = FactoryBot.create(:nil_lesson_detail, lesson_id: lesson.id)

      lesson.evaluations = []
      lesson.evaluations << FactoryBot.create(:nil_evaluation, lesson_id: lesson.id)

      lesson.lesson_schedules = []
      lesson.lesson_schedules << FactoryBot.create(:nil_lesson_schedule, lesson_id: lesson.id)

      document = TextBook.create!
      lesson.text_book_lessons = []
      lesson.text_book_lessons << FactoryBot.create(:text_book_lesson, {
        lesson_id: lesson.id,
        text_book_id: document.id,
        book_type: 0
      })
    end
  end
end
