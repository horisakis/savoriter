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

ActiveRecord::Schema.define(version: 20180620040621) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auths", force: :cascade do |t|
    t.bigint "user_id"
    t.string "uid", null: false
    t.string "provider", null: false
    t.string "token", null: false
    t.string "secret_token", null: false
    t.string "expires_at"
    t.boolean "destination", default: false, null: false
    t.bigint "since_id"
    t.datetime "save_at"
    t.text "save_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid", "provider"], name: "index_auths_on_uid_and_provider", unique: true
    t.index ["user_id"], name: "index_auths_on_user_id"
  end

  create_table "contents", force: :cascade do |t|
    t.string "provider", null: false
    t.bigint "source_id", null: false
    t.text "url", null: false
    t.text "oembed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "content_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_id"], name: "index_favorites_on_content_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
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
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "auths", "users"
  add_foreign_key "favorites", "contents"
  add_foreign_key "favorites", "users"
end
