# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_07_12_015925) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "buisiness_times", force: :cascade do |t|
    t.integer "item_category_id", null: false
    t.integer "sales_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_category_id"], name: "index_buisiness_times_on_item_category_id"
  end

  create_table "charactor_tickets", force: :cascade do |t|
    t.integer "ticket_id"
    t.integer "charactor_id"
    t.boolean "used", default: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "charactors", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.integer "exp", default: 0
    t.integer "motion_level", default: 1
    t.integer "knowledge_level", default: 1
    t.integer "health_level", default: 1
    t.integer "communication_level", default: 1
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "motion_exp", default: 0
    t.integer "knowledge_exp", default: 0
    t.integer "health_exp", default: 0
    t.integer "communication_exp", default: 0
    t.integer "total_exp", default: 0
    t.integer "shop_point", default: 0
  end

  create_table "experiences", force: :cascade do |t|
    t.string "name"
    t.string "unit"
    t.integer "unit_exp"
    t.integer "level", default: 1
    t.integer "exp", default: 0
    t.string "explanation"
    t.integer "charactor_id"
    t.integer "category_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "import_htmls", force: :cascade do |t|
    t.integer "managed_html_id"
    t.integer "import_html_id"
    t.integer "asset_type"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "item_categories", force: :cascade do |t|
    t.integer "store_category_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_category_id"], name: "index_item_categories_on_store_category_id"
  end

  create_table "items", force: :cascade do |t|
    t.integer "town_id", null: false
    t.integer "user_id", null: false
    t.string "name", null: false
    t.string "description", null: false
    t.integer "item_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_category_id"], name: "index_items_on_item_category_id"
    t.index ["town_id"], name: "index_items_on_town_id"
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "managed_htmls", force: :cascade do |t|
    t.string "title"
    t.integer "user_id"
    t.boolean "public", default: false, null: false
    t.text "body"
    t.text "js_body"
    t.text "css_body"
    t.string "note"
    t.text "yaml"
    t.boolean "use_yaml", default: true
    t.integer "level"
    t.string "js_note"
    t.string "css_note"
    t.string "address"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "materials", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_materials_on_item_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "store_id"
    t.integer "user_id", null: false
    t.integer "cost", null: false
    t.integer "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_stocks_on_item_id"
    t.index ["store_id"], name: "index_stocks_on_store_id"
    t.index ["user_id"], name: "index_stocks_on_user_id"
  end

  create_table "store_categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stores", force: :cascade do |t|
    t.integer "town_id", null: false
    t.string "name", null: false
    t.string "theme_color", null: false
    t.string "theme_sub_color", null: false
    t.integer "user_id", null: false
    t.integer "store_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_category_id"], name: "index_stores_on_store_category_id"
    t.index ["town_id"], name: "index_stores_on_town_id"
    t.index ["user_id"], name: "index_stores_on_user_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "title"
    t.string "color"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "point", default: 100
    t.integer "charactor_id"
  end

  create_table "towns", force: :cascade do |t|
    t.string "name", null: false
    t.integer "user_id", null: false
    t.string "password", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_towns", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "town_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["town_id"], name: "index_user_towns_on_town_id"
    t.index ["user_id"], name: "index_user_towns_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "name"
    t.integer "town_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["town_id"], name: "index_users_on_town_id"
  end

  create_table "vrs", force: :cascade do |t|
    t.integer "user_id"
    t.string "title"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "buisiness_times", "item_categories"
  add_foreign_key "item_categories", "store_categories"
  add_foreign_key "items", "item_categories"
  add_foreign_key "items", "towns"
  add_foreign_key "items", "users"
  add_foreign_key "materials", "items"
  add_foreign_key "stocks", "items"
  add_foreign_key "stocks", "stores"
  add_foreign_key "stocks", "users"
  add_foreign_key "stores", "store_categories"
  add_foreign_key "stores", "towns"
  add_foreign_key "stores", "users"
  add_foreign_key "user_towns", "towns"
  add_foreign_key "user_towns", "users"
  add_foreign_key "users", "towns"
end
