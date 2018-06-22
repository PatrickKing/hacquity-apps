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

ActiveRecord::Schema.define(version: 2018_06_22_034412) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "connection_requests", force: :cascade do |t|
    t.bigint "initiator_id"
    t.bigint "receiver_id"
    t.bigint "initiator_service_posting_id"
    t.bigint "receiver_service_posting_id"
    t.string "receiver_status"
    t.string "initiator_status"
    t.string "connection_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["initiator_id"], name: "index_connection_requests_on_initiator_id"
    t.index ["initiator_service_posting_id"], name: "index_connection_requests_on_initiator_service_posting_id"
    t.index ["receiver_id"], name: "index_connection_requests_on_receiver_id"
    t.index ["receiver_service_posting_id"], name: "index_connection_requests_on_receiver_service_posting_id"
  end

  create_table "mentor_match_profiles", force: :cascade do |t|
    t.bigint "user_id"
    t.string "cv_text"
    t.string "match_role"
    t.string "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "original_cv_drive_id"
    t.string "cv_gdoc_drive_id"
    t.boolean "uploaded_cv_exists"
    t.index "to_tsvector('english'::regconfig, (cv_text)::text)", name: "profile_text_idx", using: :gin
    t.index ["user_id"], name: "index_mentor_match_profiles_on_user_id"
  end

  create_table "service_postings", force: :cascade do |t|
    t.string "posting_type"
    t.string "summary"
    t.string "description"
    t.decimal "full_time_equivalents"
    t.bigint "user_id"
    t.boolean "closed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "service_type"
    t.index ["user_id"], name: "index_service_postings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.boolean "second_shift_enabled"
    t.boolean "mentor_match_enabled"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "connection_requests", "service_postings", column: "initiator_service_posting_id"
  add_foreign_key "connection_requests", "service_postings", column: "receiver_service_posting_id"
  add_foreign_key "connection_requests", "users", column: "initiator_id"
  add_foreign_key "connection_requests", "users", column: "receiver_id"
  add_foreign_key "mentor_match_profiles", "users"
  add_foreign_key "service_postings", "users"
end
