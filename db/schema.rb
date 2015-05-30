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

ActiveRecord::Schema.define(version: 20150529235300) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_logs", force: :cascade do |t|
    t.string   "type"
    t.integer  "target_id"
    t.string   "target_type"
    t.text     "description"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.date     "date"
    t.integer  "related_id"
    t.string   "related_type"
  end

  add_index "activity_logs", ["related_type", "related_id"], name: "index_activity_logs_on_related_type_and_related_id", using: :btree
  add_index "activity_logs", ["target_type", "target_id"], name: "index_activity_logs_on_target_type_and_target_id", using: :btree

  create_table "course_logs", force: :cascade do |t|
    t.integer  "course_id"
    t.date     "date"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "missing",    default: false, null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "weekday"
    t.date     "valid_since"
  end

  create_table "ona_submissions", force: :cascade do |t|
    t.string   "form"
    t.text     "data"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "log"
  end

  create_table "payment_plans", force: :cascade do |t|
    t.string   "code"
    t.string   "description"
    t.decimal  "price"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "student_course_logs", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "course_log_id"
    t.integer  "teacher_id"
    t.text     "payload"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.decimal  "payment_amount"
    t.string   "payment_status"
    t.integer  "payment_plan_id"
    t.integer  "ona_submission_id"
    t.string   "ona_submission_path"
    t.datetime "transferred_at"
  end

  add_index "student_course_logs", ["course_log_id"], name: "index_student_course_logs_on_course_log_id", using: :btree
  add_index "student_course_logs", ["ona_submission_id"], name: "index_student_course_logs_on_ona_submission_id", using: :btree
  add_index "student_course_logs", ["payment_plan_id"], name: "index_student_course_logs_on_payment_plan_id", using: :btree
  add_index "student_course_logs", ["student_id"], name: "index_student_course_logs_on_student_id", using: :btree
  add_index "student_course_logs", ["teacher_id"], name: "index_student_course_logs_on_teacher_id", using: :btree

  create_table "students", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "card_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teacher_course_logs", force: :cascade do |t|
    t.integer  "teacher_id"
    t.integer  "course_log_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.boolean  "paid"
    t.decimal  "paid_amount"
    t.datetime "paid_at"
  end

  add_index "teacher_course_logs", ["course_log_id"], name: "index_teacher_course_logs_on_course_log_id", using: :btree
  add_index "teacher_course_logs", ["teacher_id"], name: "index_teacher_course_logs_on_teacher_id", using: :btree

  create_table "teachers", force: :cascade do |t|
    t.string   "name"
    t.string   "card"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal  "fee"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "student_course_logs", "course_logs"
  add_foreign_key "student_course_logs", "ona_submissions"
  add_foreign_key "student_course_logs", "payment_plans"
  add_foreign_key "student_course_logs", "students"
  add_foreign_key "student_course_logs", "teachers"
  add_foreign_key "teacher_course_logs", "course_logs"
  add_foreign_key "teacher_course_logs", "teachers"
end
