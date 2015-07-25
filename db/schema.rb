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

ActiveRecord::Schema.define(version: 20150723181840) do

  create_table "courses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "courses", ["user_id"], name: "index_courses_on_user_id"

  create_table "employments", force: true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.integer  "hours_per_week"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employments", ["course_id"], name: "index_employments_on_course_id"
  add_index "employments", ["user_id"], name: "index_employments_on_user_id"

  create_table "preferences", force: true do |t|
    t.integer  "user_id"
    t.integer  "section_id"
    t.integer  "preference"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "preferences", ["section_id"], name: "index_preferences_on_section_id"
  add_index "preferences", ["user_id"], name: "index_preferences_on_user_id"

  create_table "sections", force: true do |t|
    t.string   "name"
    t.string   "weekday"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "room"
    t.integer  "course_id"
    t.integer  "gsi_id"
    t.string   "lecture"
    t.integer  "start_hour",     limit: 1
    t.integer  "start_minute",   limit: 1
    t.decimal  "duration_hours",           precision: 6, scale: 3
  end

  add_index "sections", ["course_id"], name: "index_sections_on_course_id"
  add_index "sections", ["gsi_id"], name: "index_sections_on_gsi_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.text     "auth_token"
    t.string   "email",                  default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
