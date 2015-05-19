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

ActiveRecord::Schema.define(version: 20150519220111) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "course_logs", force: :cascade do |t|
    t.integer  "course_id"
    t.date     "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ona_submissions", force: :cascade do |t|
    t.string   "form"
    t.text     "data"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "log"
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

  add_foreign_key "teacher_course_logs", "course_logs"
  add_foreign_key "teacher_course_logs", "teachers"
end
