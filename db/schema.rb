# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20200128005404) do

  create_table "activity_logs", force: :cascade do |t|
    t.string   "type",         limit: 255
    t.integer  "target_id",    limit: 4
    t.string   "target_type",  limit: 255
    t.text     "description",  limit: 65535
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.date     "date"
    t.integer  "related_id",   limit: 4
    t.string   "related_type", limit: 255
  end

  add_index "activity_logs", ["related_type", "related_id"], name: "index_activity_logs_on_related_type_and_related_id", using: :btree
  add_index "activity_logs", ["target_type", "target_id"], name: "index_activity_logs_on_target_type_and_target_id", using: :btree

  create_table "cards", force: :cascade do |t|
    t.string   "code",       limit: 255
    t.integer  "student_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "cards", ["student_id"], name: "index_cards_on_student_id", using: :btree

  create_table "course_logs", force: :cascade do |t|
    t.integer  "course_id",                limit: 4
    t.date     "date"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.boolean  "missing",                  limit: 1, default: false, null: false
    t.integer  "untracked_students_count", limit: 4, default: 0,     null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "code",        limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "weekday",     limit: 4
    t.date     "valid_since"
    t.date     "valid_until"
    t.integer  "place_id",    limit: 4,   null: false
    t.integer  "track_id",    limit: 4
    t.time     "start_time"
    t.string   "hashtag",     limit: 255
  end

  add_index "courses", ["place_id"], name: "index_courses_on_place_id", using: :btree
  add_index "courses", ["track_id"], name: "index_courses_on_track_id", using: :btree

  create_table "fixed_fees", force: :cascade do |t|
    t.string   "code",       limit: 255
    t.string   "name",       limit: 255
    t.decimal  "value",                  precision: 10
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "ona_submission_subscriptions", force: :cascade do |t|
    t.integer  "ona_submission_id", limit: 4
    t.integer  "follower_id",       limit: 4
    t.string   "follower_type",     limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "ona_submissions", force: :cascade do |t|
    t.string   "form",       limit: 255
    t.text     "data",       limit: 65535
    t.string   "status",     limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "log",        limit: 65535
  end

  create_table "payment_plans", force: :cascade do |t|
    t.string   "code",           limit: 255
    t.string   "description",    limit: 255
    t.decimal  "price",                      precision: 10, scale: 2
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "weekly_classes", limit: 4
    t.integer  "order",          limit: 4
    t.string   "course_match",   limit: 255
  end

  create_table "places", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "address",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "link",       limit: 255
    t.datetime "deleted_at"
  end

  create_table "student_course_logs", force: :cascade do |t|
    t.integer  "student_id",            limit: 4
    t.integer  "course_log_id",         limit: 4
    t.integer  "teacher_id",            limit: 4
    t.text     "payload",               limit: 65535
    t.datetime "created_at",                                                                   null: false
    t.datetime "updated_at",                                                                   null: false
    t.decimal  "payment_amount",                      precision: 10, scale: 2
    t.integer  "payment_plan_id",       limit: 4
    t.integer  "ona_submission_id",     limit: 4
    t.string   "ona_submission_path",   limit: 255
    t.string   "id_kind",               limit: 255
    t.boolean  "requires_student_pack", limit: 1,                              default: true,  null: false
    t.integer  "student_pack_id",       limit: 4
    t.boolean  "as_helper",             limit: 1,                              default: false, null: false
  end

  add_index "student_course_logs", ["course_log_id"], name: "index_student_course_logs_on_course_log_id", using: :btree
  add_index "student_course_logs", ["ona_submission_id"], name: "index_student_course_logs_on_ona_submission_id", using: :btree
  add_index "student_course_logs", ["payment_plan_id"], name: "index_student_course_logs_on_payment_plan_id", using: :btree
  add_index "student_course_logs", ["student_id"], name: "index_student_course_logs_on_student_id", using: :btree
  add_index "student_course_logs", ["student_pack_id"], name: "index_student_course_logs_on_student_pack_id", using: :btree
  add_index "student_course_logs", ["teacher_id"], name: "index_student_course_logs_on_teacher_id", using: :btree

  create_table "student_packs", force: :cascade do |t|
    t.integer  "student_id",      limit: 4
    t.integer  "payment_plan_id", limit: 4
    t.date     "start_date",                null: false
    t.date     "due_date",                  null: false
    t.integer  "max_courses",     limit: 4, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "student_packs", ["payment_plan_id"], name: "index_student_packs_on_payment_plan_id", using: :btree
  add_index "student_packs", ["student_id"], name: "index_student_packs_on_student_id", using: :btree

  create_table "students", force: :cascade do |t|
    t.string   "first_name",    limit: 255
    t.string   "last_name",     limit: 255
    t.string   "email",         limit: 255
    t.string   "card_code",     limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "known_by",      limit: 255
    t.text     "comment",       limit: 65535
    t.datetime "comment_at"
    t.integer  "comment_by_id", limit: 4
  end

  create_table "students_lifespan", id: false, force: :cascade do |t|
    t.integer "id",                limit: 4,   default: 0, null: false
    t.string  "card_code",         limit: 255
    t.string  "first_name",        limit: 255
    t.string  "last_name",         limit: 255
    t.string  "email",             limit: 255
    t.date    "first_course_log"
    t.date    "last_course_log"
    t.integer "course_logs_count", limit: 8,   default: 0, null: false
    t.integer "lifespan",          limit: 4
  end

  create_table "teacher_cash_incomes", force: :cascade do |t|
    t.integer  "teacher_id",            limit: 4
    t.string   "type",                  limit: 255
    t.decimal  "payment_amount",                    precision: 10, scale: 2
    t.string   "payment_status",        limit: 255
    t.datetime "transferred_at"
    t.integer  "student_course_log_id", limit: 4
    t.integer  "course_log_id",         limit: 4
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.date     "date"
    t.integer  "place_id",              limit: 4
    t.integer  "student_id",            limit: 4
    t.string   "description",           limit: 255
  end

  add_index "teacher_cash_incomes", ["course_log_id"], name: "index_teacher_cash_incomes_on_course_log_id", using: :btree
  add_index "teacher_cash_incomes", ["place_id"], name: "index_teacher_cash_incomes_on_place_id", using: :btree
  add_index "teacher_cash_incomes", ["student_course_log_id"], name: "index_teacher_cash_incomes_on_student_course_log_id", using: :btree
  add_index "teacher_cash_incomes", ["student_id"], name: "index_teacher_cash_incomes_on_student_id", using: :btree
  add_index "teacher_cash_incomes", ["teacher_id"], name: "index_teacher_cash_incomes_on_teacher_id", using: :btree

  create_table "teacher_course_logs", force: :cascade do |t|
    t.integer  "teacher_id",    limit: 4
    t.integer  "course_log_id", limit: 4
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.boolean  "paid",          limit: 1
    t.decimal  "paid_amount",             precision: 10, scale: 2
    t.datetime "paid_at"
  end

  add_index "teacher_course_logs", ["course_log_id"], name: "index_teacher_course_logs_on_course_log_id", using: :btree
  add_index "teacher_course_logs", ["teacher_id"], name: "index_teacher_course_logs_on_teacher_id", using: :btree

  create_table "teachers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "card",       limit: 255
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.decimal  "fee",                    precision: 10, scale: 2
    t.boolean  "cashier",    limit: 1,                            default: false, null: false
    t.integer  "priority",   limit: 4
    t.datetime "deleted_at"
  end

  create_table "tracks", force: :cascade do |t|
    t.string   "code",        limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "course_kind", limit: 255
    t.string   "name",        limit: 255
    t.string   "color",       limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.boolean  "admin",                  limit: 1,   default: false
    t.integer  "teacher_id",             limit: 4
    t.integer  "place_id",               limit: 4
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["place_id"], name: "index_users_on_place_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["teacher_id"], name: "index_users_on_teacher_id", using: :btree

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
