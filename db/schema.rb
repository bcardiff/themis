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

ActiveRecord::Schema.define(version: 20150527014328) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "double_entry_account_balances", force: :cascade do |t|
    t.string   "account",    limit: 31, null: false
    t.string   "scope",      limit: 23
    t.integer  "balance",               null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "double_entry_account_balances", ["account"], name: "index_account_balances_on_account", using: :btree
  add_index "double_entry_account_balances", ["scope", "account"], name: "index_account_balances_on_scope_and_account", unique: true, using: :btree

  create_table "double_entry_line_aggregates", force: :cascade do |t|
    t.string   "function",   limit: 15, null: false
    t.string   "account",    limit: 31, null: false
    t.string   "code",       limit: 47
    t.string   "scope",      limit: 23
    t.integer  "year"
    t.integer  "month"
    t.integer  "week"
    t.integer  "day"
    t.integer  "hour"
    t.integer  "amount",                null: false
    t.string   "filter"
    t.string   "range_type", limit: 15, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "double_entry_line_aggregates", ["function", "account", "code", "year", "month", "week", "day"], name: "line_aggregate_idx", using: :btree

  create_table "double_entry_line_checks", force: :cascade do |t|
    t.integer  "last_line_id", null: false
    t.boolean  "errors_found", null: false
    t.text     "log"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "double_entry_lines", force: :cascade do |t|
    t.string   "account",         limit: 31, null: false
    t.string   "scope",           limit: 23
    t.string   "code",            limit: 47, null: false
    t.integer  "amount",                     null: false
    t.integer  "balance",                    null: false
    t.integer  "partner_id"
    t.string   "partner_account", limit: 31, null: false
    t.string   "partner_scope",   limit: 23
    t.integer  "detail_id"
    t.string   "detail_type"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "double_entry_lines", ["account", "code", "created_at"], name: "lines_account_code_created_at_idx", using: :btree
  add_index "double_entry_lines", ["account", "created_at"], name: "lines_account_created_at_idx", using: :btree
  add_index "double_entry_lines", ["scope", "account", "created_at"], name: "lines_scope_account_created_at_idx", using: :btree
  add_index "double_entry_lines", ["scope", "account", "id"], name: "lines_scope_account_id_idx", using: :btree

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
  end

  add_index "teacher_course_logs", ["course_log_id"], name: "index_teacher_course_logs_on_course_log_id", using: :btree
  add_index "teacher_course_logs", ["teacher_id"], name: "index_teacher_course_logs_on_teacher_id", using: :btree

  create_table "teachers", force: :cascade do |t|
    t.string   "name"
    t.string   "card"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "student_course_logs", "course_logs"
  add_foreign_key "student_course_logs", "ona_submissions"
  add_foreign_key "student_course_logs", "payment_plans"
  add_foreign_key "student_course_logs", "students"
  add_foreign_key "student_course_logs", "teachers"
  add_foreign_key "teacher_course_logs", "course_logs"
  add_foreign_key "teacher_course_logs", "teachers"
end
