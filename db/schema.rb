# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180728122431) do

  create_table "book_requests", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "having_user_id"
    t.integer "request_user_id"
    t.integer "text_book_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["text_book_id"], name: "index_book_requests_on_text_book_id"
  end

  create_table "book_stores", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "text_book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_sold"
    t.index ["text_book_id"], name: "index_book_stores_on_text_book_id"
  end

  create_table "categories", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.boolean "published"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "category_features", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "category_id"
    t.integer "feature_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_category_features_on_category_id"
    t.index ["feature_id"], name: "index_category_features_on_feature_id"
  end

  create_table "chat_rooms", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.boolean "published"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "faculty_id"
    t.index ["faculty_id"], name: "index_chat_rooms_on_faculty_id"
    t.index ["user_id"], name: "index_chat_rooms_on_user_id"
  end

  create_table "departments", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "department_name"
    t.integer "faculty_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: false, null: false
    t.string "code"
    t.index ["faculty_id"], name: "index_departments_on_faculty_id"
  end

  create_table "evaluations", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "lesson_id"
    t.string "kind"
    t.integer "percent"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_evaluations_on_lesson_id"
  end

  create_table "faculties", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "faculty_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "faculty_features", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "faculty_id"
    t.integer "feature_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["faculty_id"], name: "index_faculty_features_on_faculty_id"
    t.index ["feature_id"], name: "index_faculty_features_on_feature_id"
  end

  create_table "favorites", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "user_id", null: false
    t.integer "lesson_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_favorites_on_lesson_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "features", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "title"
    t.text "content"
    t.boolean "published", default: false
    t.datetime "published_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
  end

  create_table "lesson_details", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "lesson_id"
    t.text "code_title", limit: 16777215
    t.text "theme_subtitle", limit: 16777215
    t.text "professor", limit: 16777215
    t.string "term"
    t.string "credit"
    t.string "number"
    t.string "language"
    t.text "notes", limit: 16777215
    t.text "objectives", limit: 16777215
    t.text "content", limit: 16777215
    t.text "outside_study", limit: 16777215
    t.text "evaluation", limit: 16777215
    t.text "textbook", limit: 16777215
    t.text "reading", limit: 16777215
    t.text "others", limit: 16777215
    t.text "info", limit: 16777215
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_lesson_details_on_lesson_id"
  end

  create_table "lesson_schedules", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "lesson_id"
    t.integer "number"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_lesson_schedules_on_lesson_id"
  end

  create_table "lessons", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "lesson_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "faculty_id"
    t.integer "department_id"
    t.string "lesson_number"
    t.string "lesson_code"
    t.string "professor_name"
    t.integer "term"
    t.string "period"
    t.string "classroom"
    t.text "note"
    t.integer "campus"
    t.string "url"
    t.integer "year"
    t.integer "topic_id"
    t.integer "tag"
    t.string "same_lessons"
    t.index ["department_id"], name: "index_lessons_on_department_id"
    t.index ["faculty_id"], name: "index_lessons_on_faculty_id"
    t.index ["lesson_name"], name: "index_lessons_on_lesson_name"
    t.index ["period"], name: "index_lessons_on_period"
    t.index ["professor_name"], name: "index_lessons_on_professor_name"
    t.index ["same_lessons"], name: "index_lessons_on_same_lessons"
    t.index ["topic_id"], name: "index_lessons_on_topic_id"
  end

  create_table "matched_users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "having_user_id", null: false
    t.integer "request_user_id", null: false
    t.integer "matchable_id", null: false
    t.string "matchable_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "messageable_id"
    t.string "messageable_type"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "posts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "content"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "chat_room_id"
    t.index ["chat_room_id"], name: "index_posts_on_chat_room_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "results", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "grade"
    t.integer "score"
    t.integer "lesson_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rep_1"
    t.integer "rep_2"
    t.integer "rep_3"
    t.text "comment"
  end

  create_table "text_book_lessons", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "text_book_id", null: false
    t.integer "lesson_id", null: false
    t.integer "book_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_text_book_lessons_on_lesson_id"
    t.index ["text_book_id"], name: "index_text_book_lessons_on_text_book_id"
  end

  create_table "text_books", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "author"
    t.text "title"
    t.string "publisher"
    t.string "published_year"
    t.string "isbn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "amazon_title"
    t.string "amazon_author"
    t.text "amazon_page"
    t.text "medium_image"
    t.text "large_image"
    t.string "amazon_isbn"
    t.string "amazon_publisher"
    t.date "published_date"
    t.integer "lowest_new_price"
    t.string "asin"
  end

  create_table "timetable_lessons", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "lesson_id"
    t.integer "timetable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_timetable_lessons_on_lesson_id"
    t.index ["timetable_id"], name: "index_timetable_lessons_on_timetable_id"
  end

  create_table "timetables", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "user_id"
    t.integer "year", null: false
    t.integer "term", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_timetables_on_user_id"
  end

  create_table "topics", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "department_id"
    t.integer "faculty_id"
    t.datetime "readed_at"
    t.string "token", collation: "utf8_bin"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["faculty_id"], name: "index_users_on_faculty_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "book_requests", "text_books"
  add_foreign_key "book_stores", "text_books"
  add_foreign_key "category_features", "categories"
  add_foreign_key "category_features", "features"
  add_foreign_key "chat_rooms", "faculties"
  add_foreign_key "chat_rooms", "users"
  add_foreign_key "departments", "faculties"
  add_foreign_key "evaluations", "lessons"
  add_foreign_key "faculty_features", "faculties"
  add_foreign_key "faculty_features", "features"
  add_foreign_key "lesson_details", "lessons"
  add_foreign_key "lesson_schedules", "lessons"
  add_foreign_key "lessons", "departments"
  add_foreign_key "lessons", "faculties"
  add_foreign_key "lessons", "topics"
  add_foreign_key "messages", "users"
  add_foreign_key "posts", "chat_rooms"
  add_foreign_key "posts", "users"
  add_foreign_key "text_book_lessons", "lessons"
  add_foreign_key "text_book_lessons", "text_books"
  add_foreign_key "timetable_lessons", "lessons"
  add_foreign_key "timetable_lessons", "timetables"
  add_foreign_key "timetables", "users"
  add_foreign_key "users", "departments"
  add_foreign_key "users", "faculties"
end
