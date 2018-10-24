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

ActiveRecord::Schema.define(version: 2018_10_15_193452) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "admin_accounts", force: :cascade do |t|
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
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_admin_accounts_on_confirmation_token", unique: true
    t.index ["email"], name: "index_admin_accounts_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_accounts_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_admin_accounts_on_unlock_token", unique: true
  end

# Could not dump table "courses" because of following StandardError
#   Unknown type 'category' for column 'category'

  create_table "enrollments", force: :cascade do |t|
    t.decimal "user_rating"
    t.text "description"
    t.string "tracked_url"
    t.bigint "user_account_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_enrollments_on_course_id"
    t.index ["user_account_id"], name: "index_enrollments_on_user_account_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "caption"
    t.string "file"
    t.integer "pos", default: 0
    t.string "imageable_type"
    t.integer "imageable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oauth_accounts", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.jsonb "raw_data", default: {}, null: false
    t.bigint "user_account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_account_id"], name: "index_oauth_accounts_on_user_account_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.date "date_of_birth"
    t.string "avatar"
    t.text "interests", default: [], array: true
    t.jsonb "preferences", default: {}
    t.bigint "user_account_id"
    t.index ["user_account_id"], name: "index_profiles_on_user_account_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "slug"
    t.string "afn_url_template"
    t.boolean "published"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_accounts", force: :cascade do |t|
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
    t.json "tracking_data", default: {}, null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "destroyed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_user_accounts_on_confirmation_token", unique: true
    t.index ["email"], name: "index_user_accounts_on_email", unique: true
    t.index ["reset_password_token"], name: "index_user_accounts_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_user_accounts_on_unlock_token", unique: true
  end

  add_foreign_key "oauth_accounts", "user_accounts"
  add_foreign_key "profiles", "user_accounts"
end
