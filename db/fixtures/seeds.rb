# -*- coding: utf-8 -*-
require "csv"
# require "pry"

# faculty_csv = CSV.read('db/fixtures/faculty.csv')
# faculty_csv.each.with_index(1) do |row, i|
#   faculty_name = row[0]
#
#   Faculty.seed do |s|
#     s.id = i
#     s.faculty_name = faculty_name
#   end
# end
# department_csv = CSV.read('db/fixtures/department.csv')
# department_csv.each do |row|
#   id = row[0]
#   department_name = row[1]
#   faculty_id = row[2]
#   published = row[3]
#   code = row[4]
#
#   Department.seed do |s|
#     s.id = id
#     s.department_name = department_name
#     s.faculty_id = faculty_id
#     s.published = published
#     s.code = code
#   end
# end


# 現在の授業数
# Lesson.last.idの値など

# 2017年のデータを読む時
# 授業データの年度
year = "2017"
LESSON_COUNT = 2052
TEXTBOOK_COUNT = 0
TEXTBOOKLESSON_COUNT = 0

# 2018年のデータを読む時
# 授業データの年度
# year = "2018"
# LESSON_COUNT = 12372
# SCHEDULE_COUNT = 152819
# TEXTBOOK_COUNT = 9936
# TEXTBOOKLESSON_COUNT = 9937
# EVALUATION_COUNT = 14266

Dir.glob("#{Rails.root}/db/fixtures/#{year}/*.csv").sort!.each do |f|
  CSV.read(f).each do |row|
    Lesson.seed do |s|
      # idに最後のLessonのidである12355を足す。
      s.id = row[0].to_i + LESSON_COUNT
      s.faculty_id = row[1]
      s.department_id = row[2]
      s.lesson_number = row[3]
      s.lesson_code = row[4]
      s.lesson_name = row[5]
      s.professor_name = row[6]
      s.term = row[7]
      s.period = row[8].to_s
      s.classroom = row[9]
      s.campus = row[10]
      s.note = row[11]
      s.url = row[12]
      s.year = row[13]
    end
  end
  puts "#{f}---完了！"
end

Dir.glob("#{Rails.root}/db/fixtures/#{year}/lesson_detail*/*.csv").sort!.each do |f|
  CSV.read(f).each do |row|
    LessonDetail.seed do |s|
      # idに最後のLessonのidである12355を足す。
      s.id = row[0].to_i + LESSON_COUNT
      s.lesson_id = row[0].to_i + LESSON_COUNT
      s.code_title = row[1]
      s.theme_subtitle = row[2]
      s.professor = row[3]
      s.term = row[4]
      s.credit = row[5]
      s.number = row[6]
      s.language = row[7]
      s.notes = row[8].to_s
      s.objectives = row[9]
      s.content = row[10]
      s.outside_study = row[11]
      s.evaluation = row[12]
      s.textbook = row[13]
      s.reading = row[14]
      s.others = row[15]
      s.info = row[16]
    end
  end
end

id_num = SCHEDULE_COUNT + 1
Dir.glob("#{Rails.root}/db/fixtures/#{year}/lesson_schedule*/*.csv").sort!.each do |f|
  CSV.read(f).each do |row|
    LessonSchedule.seed do |s|
      s.id = id_num
      s.lesson_id = row[0].to_i + LESSON_COUNT
      s.number = row[1]
      s.content = row[2]
      id_num += 1
    end
  end
end

# idのincrementをresetしてレコードを全件削除
# 2017年度の時だけ
if year == '2017'
  TextBookLesson.delete_all
  TextBook.delete_all
end

class BookSeed
  def self.create_book_seed(row, type, id_num, tb_lesson_id)
    author = row[1]
    title = row[2]
    publisher = row[3]
    published_year = row[4]

    # 同じ、タイトル、筆者、出版年のTextBookを検索
    tb = TextBook.where(title: title, author: author, publisher: publisher, published_year: published_year)
    lesson_id = row[0].to_i + LESSON_COUNT

    # すでに同じTextBookがある場合
    if tb.present?
      # id_numにその同じ教科書のidを代入
      # 更新対象
      id_num = tb.first.id

      # amazon_titleの有無で更新していく。
      # 同じ教科書に、amazon_titleがblank?で、
      # かつ、追加するデータにamazon_titleがある場合、seedを実行する
      if tb.first.amazon_title.blank? && row[6].present?
        create_seed = true
      else
        create_seed = false
      end
    else
      # 同じ教科書がない場合
      # seedを実行する
      create_seed = true
    end

    # create_seedがtrueの場合実行する。
    # 同じ教科書があっても、amazon_titleがnilの場合更新対象
    if create_seed
      TextBook.seed do |s|
        s.id = id_num
        s.author = author
        s.title = title
        s.publisher = publisher
        s.published_year = published_year
        s.isbn = row[5]
        s.amazon_title = row[6]
        s.amazon_author = row[7]
        s.amazon_isbn = row[8]
        s.amazon_publisher = row[9]
        s.published_date = row[10]
        s.lowest_new_price = row[11]
        s.amazon_page = row[12]
        s.medium_image = row[13]
        s.large_image = row[14]
        s.asin = row[15]
      end
    end

    create_textbook_lesson(tb_lesson_id, lesson_id, id_num, type)
  end

  def self.create_textbook_lesson(tb_lesson_id, lesson_id, id_num, type)
    TextBookLesson.seed do |tl|
      tl.id = tb_lesson_id
      tl.lesson_id = lesson_id
      tl.text_book_id = id_num
      tl.book_type = type
    end
  end

end

id_num = TEXTBOOK_COUNT + 1
tb_lesson_id = TEXTBOOKLESSON_COUNT + 1
Dir.glob("#{Rails.root}/db/fixtures/#{year}/lesson_document*/*.csv").sort!.each do |f|
  CSV.read(f).each do |row|
    type = 0
    BookSeed.create_book_seed(row, type, id_num, tb_lesson_id)
    id_num += 1
    tb_lesson_id += 1
  end
end
Dir.glob("#{Rails.root}/db/fixtures/#{year}/lesson_textbook*/*.csv").sort!.each do |f|
  CSV.read(f).each do |row|
    type = 1
    BookSeed.create_book_seed(row, type, id_num, tb_lesson_id)
    id_num += 1
    tb_lesson_id += 1
  end
end

id_num = EVALUATION_COUNT + 1
Dir.glob("#{Rails.root}/db/fixtures/#{year}/lesson_evaluation*/*.csv").sort!.each do |f|
  CSV.read(f).each do |row|
    Evaluation.seed do |s|
      s.id = id_num
      s.lesson_id = row[0].to_i + LESSON_COUNT
      s.kind = row[1]
      s.percent = row[2]
      s.content = row[3]
      id_num += 1
    end
  end
end


# ヒデによる分析結果のimport
# トピックの登録
topics = open("#{Rails.root}/db/fixtures/#{year}/analyzed_datasets/topic_list_27.json") do |io|
  JSON.load(io)
end
topic_last_id = Topic.last.id
topics.each do |line|
  Topic.seed do |s|
    s.id = line['topic'].to_i + topic_last_id + 1
    s.description = line['words']
  end
end
#
# # topic_idの登録
lesson_topics = open("#{Rails.root}/db/fixtures/#{year}/analyzed_datasets/topic_kv.json") do |io|
  JSON.load(io)
end
lesson_topics.each do |line|
  Lesson.seed do |s|
    s.id = line['id'].to_i
    s.topic_id = line['topic'].to_i + topic_last_id + 1
  end
end

# レコメンドタグの登録
lesson_tags = open("#{Rails.root}/db/fixtures/#{year}/analyzed_datasets/topic_kv_200.json") do |io|
  JSON.load(io)
end
lesson_tags.each do |line|
  Lesson.seed do |s|
    s.id = line['id'].to_i
    s.tag = line['topic'] + 200 # 2018年度は+200。2019年度は+400
  end
end
