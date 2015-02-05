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

ActiveRecord::Schema.define(version: 20150205224713) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body"
    t.string   "resource_id",   limit: 255, null: false
    t.string   "resource_type", limit: 255, null: false
    t.integer  "author_id"
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "phone_number"
    t.string   "carrier"
    t.string   "sms_gateway"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "closets", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title",      limit: 255
    t.text     "summary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "closets_items", id: false, force: :cascade do |t|
    t.integer "closet_id"
    t.integer "item_id"
  end

  create_table "duplicate_warnings", force: :cascade do |t|
    t.integer  "pending_item_id"
    t.integer  "existing_item_id"
    t.text     "warning_notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "match_score"
  end

  add_index "duplicate_warnings", ["existing_item_id"], name: "index_duplicate_warnings_on_existing_item_id", using: :btree
  add_index "duplicate_warnings", ["pending_item_id", "existing_item_id"], name: "by_pending_existing", unique: true, using: :btree
  add_index "duplicate_warnings", ["pending_item_id"], name: "index_duplicate_warnings_on_pending_item_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source",     limit: 255
    t.integer  "item_id"
  end

  create_table "items", force: :cascade do |t|
    t.text     "product_name"
    t.text     "description"
    t.text     "designer"
    t.integer  "price_cents"
    t.string   "currency",     limit: 255
    t.string   "store_name",   limit: 255
    t.text     "product_link"
    t.string   "category1",    limit: 255
    t.string   "category2",    limit: 255
    t.string   "category3",    limit: 255
    t.integer  "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sku",          limit: 255
    t.string   "slug",         limit: 255, null: false
  end

  add_index "items", ["slug"], name: "index_items_on_slug", unique: true, using: :btree

  create_table "likes", force: :cascade do |t|
    t.integer  "likeable_id"
    t.string   "likeable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_scrapers", force: :cascade do |t|
    t.string   "store_name"
    t.string   "detail_product_name_selector"
    t.string   "detail_description_selector"
    t.string   "detail_designer_selector"
    t.string   "detail_price_cents_selector"
    t.string   "detail_currency_selector"
    t.string   "detail_image_source_selector"
    t.string   "index_product_link_selector"
    t.string   "detail_category_selector"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "index_product_name_selector"
    t.string   "index_designer_selector"
    t.string   "index_category_selector"
    t.string   "index_item_group_selector"
    t.string   "index_price_cents_selector"
    t.string   "sku"
    t.text     "page_urls"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fb_uid",                 limit: 255
    t.string   "fb_token",               limit: 255
    t.datetime "fb_token_expiration"
    t.string   "username",               limit: 255
    t.string   "slug",                   limit: 255,              null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
