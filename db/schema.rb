# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_05_26_094948) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "answers", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.string "answer", null: false
    t.boolean "correct", default: false
    t.integer "order"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "cities", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "province_id", null: false
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "province_id"], name: "index_cities_on_name_and_province_id", unique: true
    t.index ["province_id"], name: "index_cities_on_province_id"
  end

  create_table "companies", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.string "cuit", limit: 30, null: false
    t.string "direction", limit: 100
    t.string "phone", limit: 40
    t.boolean "operator", default: false, null: false
    t.string "comment"
    t.bigint "iva_condition_id", null: false
    t.bigint "company_category_id", null: false
    t.bigint "sector_id"
    t.bigint "province_id"
    t.bigint "city_id"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_companies_on_city_id"
    t.index ["company_category_id"], name: "index_companies_on_company_category_id"
    t.index ["cuit"], name: "index_companies_on_cuit", unique: true
    t.index ["iva_condition_id"], name: "index_companies_on_iva_condition_id"
    t.index ["name"], name: "index_companies_on_name", unique: true
    t.index ["province_id"], name: "index_companies_on_province_id"
    t.index ["sector_id"], name: "index_companies_on_sector_id"
  end

  create_table "company_categories", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "description"
    t.integer "quota", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_company_categories_on_name", unique: true
  end

  create_table "company_managers", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "person_id", null: false
    t.string "email"
    t.string "job"
    t.boolean "notifications", default: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_company_managers_on_company_id"
    t.index ["person_id"], name: "index_company_managers_on_person_id"
  end

  create_table "course_exams", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "exam_id", null: false
    t.boolean "retake"
    t.integer "num_retake"
    t.integer "fleet"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_exams_on_course_id"
    t.index ["exam_id"], name: "index_course_exams_on_exam_id"
  end

  create_table "course_people", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "person_id", null: false
    t.bigint "manager_id"
    t.bigint "company_id", null: false
    t.bigint "operator_id"
    t.bigint "inscription_motive_id", null: false
    t.bigint "fleet_category_id", null: false
    t.bigint "unit_id", null: false
    t.bigint "course_unit_id", null: false
    t.date "date", null: false
    t.time "from_hour"
    t.time "to_hour"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "attendance_status"
    t.integer "scoring", default: 0
    t.integer "make_up_1", default: 0
    t.date "date_make_up_1"
    t.integer "make_up_2", default: 0
    t.date "date_make_up_2"
    t.string "code", limit: 20
    t.index ["company_id"], name: "index_course_people_on_company_id"
    t.index ["course_id"], name: "index_course_people_on_course_id"
    t.index ["course_unit_id"], name: "index_course_people_on_course_unit_id"
    t.index ["fleet_category_id"], name: "index_course_people_on_fleet_category_id"
    t.index ["inscription_motive_id"], name: "index_course_people_on_inscription_motive_id"
    t.index ["manager_id"], name: "index_course_people_on_manager_id"
    t.index ["operator_id"], name: "index_course_people_on_operator_id"
    t.index ["person_id"], name: "index_course_people_on_person_id"
    t.index ["unit_id"], name: "index_course_people_on_unit_id"
  end

  create_table "course_type_units", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "course_type_id", null: false
    t.bigint "unit_id", null: false
    t.integer "day", null: false
    t.time "start_hour"
    t.time "end_hour"
    t.boolean "is_by_turn"
    t.string "shift"
    t.integer "shift_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_type_id"], name: "index_course_type_units_on_course_type_id"
    t.index ["unit_id"], name: "index_course_type_units_on_unit_id"
  end

  create_table "course_types", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.string "description", null: false
    t.integer "max_quota", null: false
    t.integer "min_quota", null: false
    t.integer "min_score", null: false
    t.integer "max_score", null: false
    t.integer "passing_score", null: false
    t.integer "number_of_repeat", null: false
    t.boolean "need_code", default: false
    t.integer "fleet", null: false
    t.string "category", null: false
    t.bigint "room_id", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_course_types_on_room_id"
  end

  create_table "course_units", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "unit_id", null: false
    t.bigint "instructor_id", null: false
    t.string "shift"
    t.integer "day"
    t.time "start_hour"
    t.time "end_hour"
    t.date "date"
    t.integer "shift_time"
    t.integer "list"
    t.boolean "complete", default: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_units_on_course_id"
    t.index ["instructor_id"], name: "index_course_units_on_instructor_id"
    t.index ["unit_id"], name: "index_course_units_on_unit_id"
  end

  create_table "courses", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "course_type_id", null: false
    t.bigint "company_id"
    t.bigint "room_id", null: false
    t.boolean "is_company", default: false
    t.date "from_date", null: false
    t.date "to_date"
    t.string "code", limit: 10
    t.integer "year_number", null: false
    t.integer "general_number", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_courses_on_company_id"
    t.index ["course_type_id"], name: "index_courses_on_course_type_id"
    t.index ["room_id"], name: "index_courses_on_room_id"
  end

  create_table "exam_modules", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "exam_id", null: false
    t.string "name", null: false
    t.string "quote_type", null: false
    t.integer "module_order", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_id"], name: "index_exam_modules_on_exam_id"
  end

  create_table "exam_questions", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "exam_id", null: false
    t.bigint "question_id", null: false
    t.integer "question_order"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_id"], name: "index_exam_questions_on_exam_id"
    t.index ["question_id"], name: "index_exam_questions_on_question_id"
  end

  create_table "exams", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "title", null: false
    t.boolean "video"
    t.string "retake", limit: 5
    t.boolean "elearning"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fleet_categories", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "description"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_fleet_categories_on_name", unique: true
  end

  create_table "headquarters", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.string "description"
    t.string "location", limit: 100
    t.bigint "sectional_id", null: false
    t.bigint "province_id"
    t.bigint "city_id"
    t.boolean "can_make_psychometric", default: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_headquarters_on_city_id"
    t.index ["name"], name: "index_headquarters_on_name", unique: true
    t.index ["province_id"], name: "index_headquarters_on_province_id"
    t.index ["sectional_id"], name: "index_headquarters_on_sectional_id"
  end

  create_table "inscription_motives", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "description"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_inscription_motives_on_name", unique: true
  end

  create_table "instructors", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "person_id", null: false
    t.date "start_date", null: false
    t.date "end_date"
    t.boolean "theoretical", default: false
    t.boolean "practical", default: false
    t.string "code", limit: 3
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_instructors_on_person_id"
  end

  create_table "iva_conditions", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "description"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_iva_conditions_on_name", unique: true
  end

  create_table "module_questions", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "exam_module_id", null: false
    t.bigint "question_id", null: false
    t.integer "question_order", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_module_id"], name: "index_module_questions_on_exam_module_id"
    t.index ["question_id"], name: "index_module_questions_on_question_id"
  end

  create_table "module_videos", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "exam_module_id", null: false
    t.bigint "video_id", null: false
    t.integer "video_order", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_module_id"], name: "index_module_videos_on_exam_module_id"
    t.index ["video_id"], name: "index_module_videos_on_video_id"
  end

  create_table "people", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "cuil", limit: 20, null: false
    t.string "last_name", limit: 50, null: false
    t.string "name", limit: 50, null: false
    t.date "birthdate", null: false
    t.string "phone", limit: 50, null: false
    t.string "celphone", limit: 50, null: false
    t.string "email", limit: 50, null: false
    t.string "direction", limit: 100, null: false
    t.string "code", limit: 6
    t.bigint "province_id"
    t.bigint "city_id"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_people_on_city_id"
    t.index ["cuil"], name: "index_people_on_cuil", unique: true
    t.index ["province_id"], name: "index_people_on_province_id"
  end

  create_table "provinces", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "name", limit: 20, null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questionnaires", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "question"
    t.string "q_type"
    t.integer "q_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "question", null: false
    t.boolean "eliminating", default: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.integer "capacity", null: false
    t.bigint "headquarter_id", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["headquarter_id"], name: "index_rooms_on_headquarter_id"
  end

  create_table "sectionals", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "direction", null: false
    t.bigint "city_id", null: false
    t.bigint "province_id", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_sectionals_on_city_id"
    t.index ["province_id"], name: "index_sectionals_on_province_id"
  end

  create_table "sectors", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_sectors_on_name", unique: true
  end

  create_table "sessions", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "turns", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "person_id"
    t.bigint "unit_id", null: false
    t.bigint "course_unit_id", null: false
    t.date "date"
    t.time "hour"
    t.boolean "available"
    t.integer "list"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_turns_on_course_id"
    t.index ["course_unit_id"], name: "index_turns_on_course_unit_id"
    t.index ["person_id"], name: "index_turns_on_person_id"
    t.index ["unit_id"], name: "index_turns_on_unit_id"
  end

  create_table "units", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "description"
    t.string "fleet", limit: 20, null: false
    t.string "methodology", limit: 20, null: false
    t.string "category", limit: 20, null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "username", null: false
    t.string "email", null: false
    t.integer "role", null: false
    t.string "password_digest", null: false
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "videos", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "title", limit: 500, null: false
    t.string "file", limit: 100
    t.string "vimeo", limit: 100
    t.string "code", limit: 10
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answers", "questions"
  add_foreign_key "cities", "provinces"
  add_foreign_key "companies", "cities"
  add_foreign_key "companies", "company_categories"
  add_foreign_key "companies", "iva_conditions"
  add_foreign_key "companies", "provinces"
  add_foreign_key "companies", "sectors"
  add_foreign_key "company_managers", "companies"
  add_foreign_key "company_managers", "people"
  add_foreign_key "course_exams", "courses"
  add_foreign_key "course_exams", "exams"
  add_foreign_key "course_people", "companies"
  add_foreign_key "course_people", "companies", column: "operator_id"
  add_foreign_key "course_people", "course_units"
  add_foreign_key "course_people", "courses"
  add_foreign_key "course_people", "fleet_categories"
  add_foreign_key "course_people", "inscription_motives"
  add_foreign_key "course_people", "people"
  add_foreign_key "course_people", "people", column: "manager_id"
  add_foreign_key "course_people", "units"
  add_foreign_key "course_type_units", "course_types"
  add_foreign_key "course_type_units", "units"
  add_foreign_key "course_types", "rooms"
  add_foreign_key "course_units", "courses"
  add_foreign_key "course_units", "instructors"
  add_foreign_key "course_units", "units"
  add_foreign_key "courses", "companies"
  add_foreign_key "courses", "course_types"
  add_foreign_key "courses", "rooms"
  add_foreign_key "exam_modules", "exams"
  add_foreign_key "exam_questions", "exams"
  add_foreign_key "exam_questions", "questions"
  add_foreign_key "headquarters", "cities"
  add_foreign_key "headquarters", "provinces"
  add_foreign_key "headquarters", "sectionals"
  add_foreign_key "instructors", "people"
  add_foreign_key "module_questions", "exam_modules"
  add_foreign_key "module_questions", "questions"
  add_foreign_key "module_videos", "exam_modules"
  add_foreign_key "module_videos", "videos"
  add_foreign_key "people", "cities"
  add_foreign_key "people", "provinces"
  add_foreign_key "rooms", "headquarters"
  add_foreign_key "sectionals", "cities"
  add_foreign_key "sectionals", "provinces"
  add_foreign_key "sessions", "users"
  add_foreign_key "turns", "course_units"
  add_foreign_key "turns", "courses"
  add_foreign_key "turns", "people"
  add_foreign_key "turns", "units"
end
