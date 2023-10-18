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

ActiveRecord::Schema[7.0].define(version: 2020_01_28_005404) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_logs", force: :cascade do |t|
    t.string "type"
    t.string "target_type"
    t.bigint "target_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.string "related_type"
    t.bigint "related_id"
    t.index ["related_type", "related_id"], name: "index_activity_logs_on_related"
    t.index ["target_type", "target_id"], name: "index_activity_logs_on_target"
  end

  create_table "cards", force: :cascade do |t|
    t.string "code"
    t.bigint "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_cards_on_student_id"
  end

  create_table "course_logs", force: :cascade do |t|
    t.bigint "course_id"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "missing", default: false, null: false
    t.integer "untracked_students_count", default: 0, null: false
    t.index ["course_id"], name: "index_course_logs_on_course_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weekday"
    t.date "valid_since"
    t.date "valid_until"
    t.bigint "place_id", null: false
    t.bigint "track_id"
    t.time "start_time"
    t.string "hashtag"
    t.index ["place_id"], name: "index_courses_on_place_id"
    t.index ["track_id"], name: "index_courses_on_track_id"
  end

  create_table "fixed_fees", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.decimal "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ona_submission_subscriptions", force: :cascade do |t|
    t.bigint "ona_submission_id"
    t.string "follower_type"
    t.bigint "follower_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_type", "follower_id"], name: "index_ona_submission_subscriptions_on_follower"
    t.index ["ona_submission_id"], name: "index_ona_submission_subscriptions_on_ona_submission_id"
  end

  create_table "ona_submissions", force: :cascade do |t|
    t.string "form"
    t.text "data"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "log"
  end

  create_table "payment_plans", force: :cascade do |t|
    t.string "code"
    t.string "description"
    t.decimal "price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weekly_classes"
    t.integer "order"
    t.string "course_match"
  end

  create_table "places", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link"
    t.datetime "deleted_at"
  end

  create_table "student_course_logs", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "course_log_id"
    t.bigint "teacher_id"
    t.text "payload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "payment_amount", precision: 10, scale: 2
    t.bigint "payment_plan_id"
    t.bigint "ona_submission_id"
    t.string "ona_submission_path"
    t.string "id_kind"
    t.boolean "requires_student_pack", default: true, null: false
    t.bigint "student_pack_id"
    t.boolean "as_helper", default: false, null: false
    t.index ["course_log_id"], name: "index_student_course_logs_on_course_log_id"
    t.index ["ona_submission_id"], name: "index_student_course_logs_on_ona_submission_id"
    t.index ["payment_plan_id"], name: "index_student_course_logs_on_payment_plan_id"
    t.index ["student_id"], name: "index_student_course_logs_on_student_id"
    t.index ["student_pack_id"], name: "index_student_course_logs_on_student_pack_id"
    t.index ["teacher_id"], name: "index_student_course_logs_on_teacher_id"
  end

  create_table "student_packs", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "payment_plan_id"
    t.date "start_date", null: false
    t.date "due_date", null: false
    t.integer "max_courses", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payment_plan_id"], name: "index_student_packs_on_payment_plan_id"
    t.index ["student_id"], name: "index_student_packs_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "card_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "known_by"
    t.text "comment"
    t.datetime "comment_at"
    t.bigint "comment_by_id"
    t.index ["comment_by_id"], name: "index_students_on_comment_by_id"
  end

  create_table "teacher_cash_incomes", force: :cascade do |t|
    t.bigint "teacher_id"
    t.string "type"
    t.decimal "payment_amount", precision: 10, scale: 2
    t.string "payment_status"
    t.datetime "transferred_at"
    t.bigint "student_course_log_id"
    t.bigint "course_log_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.bigint "place_id"
    t.bigint "student_id"
    t.string "description"
    t.index ["course_log_id"], name: "index_teacher_cash_incomes_on_course_log_id"
    t.index ["place_id"], name: "index_teacher_cash_incomes_on_place_id"
    t.index ["student_course_log_id"], name: "index_teacher_cash_incomes_on_student_course_log_id"
    t.index ["student_id"], name: "index_teacher_cash_incomes_on_student_id"
    t.index ["teacher_id"], name: "index_teacher_cash_incomes_on_teacher_id"
  end

  create_table "teacher_course_logs", force: :cascade do |t|
    t.bigint "teacher_id"
    t.bigint "course_log_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "paid"
    t.decimal "paid_amount", precision: 10, scale: 2
    t.datetime "paid_at"
    t.index ["course_log_id"], name: "index_teacher_course_logs_on_course_log_id"
    t.index ["teacher_id"], name: "index_teacher_course_logs_on_teacher_id"
  end

  create_table "teachers", force: :cascade do |t|
    t.string "name"
    t.string "card"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "fee", precision: 10, scale: 2
    t.boolean "cashier", default: false, null: false
    t.integer "priority"
    t.datetime "deleted_at"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "course_kind"
    t.string "name"
    t.string "color"
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.bigint "teacher_id"
    t.bigint "place_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["place_id"], name: "index_users_on_place_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["teacher_id"], name: "index_users_on_teacher_id"
  end

  add_foreign_key "cards", "students"
  add_foreign_key "courses", "places"
  add_foreign_key "courses", "tracks"
  add_foreign_key "student_course_logs", "course_logs"
  add_foreign_key "student_course_logs", "ona_submissions"
  add_foreign_key "student_course_logs", "payment_plans"
  add_foreign_key "student_course_logs", "student_packs"
  add_foreign_key "student_course_logs", "students"
  add_foreign_key "student_course_logs", "teachers"
  add_foreign_key "student_packs", "payment_plans"
  add_foreign_key "student_packs", "students"
  add_foreign_key "teacher_cash_incomes", "course_logs"
  add_foreign_key "teacher_cash_incomes", "places"
  add_foreign_key "teacher_cash_incomes", "student_course_logs"
  add_foreign_key "teacher_cash_incomes", "students"
  add_foreign_key "teacher_cash_incomes", "teachers"
  add_foreign_key "teacher_course_logs", "course_logs"
  add_foreign_key "teacher_course_logs", "teachers"
  add_foreign_key "users", "places"
  add_foreign_key "users", "teachers"
end
