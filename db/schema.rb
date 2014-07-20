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

ActiveRecord::Schema.define(version: 20140720220246) do

  create_table "closets", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "summary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "closets_items", id: false, force: true do |t|
    t.integer "closet_id"
    t.integer "item_id"
  end

  create_table "duplicate_warnings", force: true do |t|
    t.integer  "pending_item_id"
    t.integer  "existing_item_id"
    t.text     "warning_notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "match_score"
  end

  add_index "duplicate_warnings", ["existing_item_id"], name: "index_duplicate_warnings_on_existing_item_id"
  add_index "duplicate_warnings", ["pending_item_id", "existing_item_id"], name: "by_pending_existing", unique: true
  add_index "duplicate_warnings", ["pending_item_id"], name: "index_duplicate_warnings_on_pending_item_id"

  create_table "items", force: true do |t|
    t.text     "product_name"
    t.text     "description"
    t.text     "designer"
    t.integer  "price_cents"
    t.string   "currency"
    t.string   "store_name"
    t.text     "image_source"
    t.text     "image_source_array"
    t.text     "product_link"
    t.string   "category1"
    t.string   "category2"
    t.string   "category3"
    t.integer  "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "likes", force: true do |t|
    t.integer  "likeable_id"
    t.string   "likeable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fb_uid"
    t.string   "fb_token"
    t.datetime "fb_token_expiration"
    t.string   "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
