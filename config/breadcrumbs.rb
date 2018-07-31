crumb :root do
  link "トップ", root_path
end

crumb :lesson_search do |search, searched_link|
  link "#{search}検索結果", searched_link
  parent :root
end

crumb :lesson_show do |lesson, search=nil, searched_link=nil|
  link lesson.lesson_name, lesson_path(lesson)
  if search.nil? || searched_link.nil?
    parent :root
  else
    parent :lesson_search, search, searched_link
  end
end

crumb :result_new do |lesson|
  link "レビューの登録"
  parent :lesson_show, lesson
end

crumb :features do |feature|
  link "特集記事"
  parent :root
end

crumb :feature_show do |feature|
  link feature.title, feature_path(feature)
  parent :features
end

crumb :pdf_index do
  link "オリジナル時間割の作成", pdfs_path
  parent :root
end

crumb :textbooks_top do
  link 'テキスト売買', textbooks_path
  parent :root
end

crumb :textbooks_search do |search, searched_link|
  link "#{search}検索結果", searched_link
  parent :textbooks_top
end

crumb :book_request do |title, book_request|
  link title, book_request_path(book_request)
  parent :textbooks_top
end

crumb :conversation do |title, parent_title, book_request|
  link title
  parent :book_request, parent_title, book_request
end

crumb :chat_rooms do
  link '掲示板一覧', chat_rooms_path
  parent :root
end

crumb :chat_room do |title|
  link title
  parent :chat_rooms
end

crumb :chat_room_new do
  link '掲示板作成'
  parent :chat_rooms
end

crumb :purchase do
  link '買取案内'
  parent :root
end
