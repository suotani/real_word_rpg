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

ActiveRecord::Schema[7.2].define(version: 2025_06_26_145335) do
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

  create_table "tickets", force: :cascade do |t|
    t.string "title"
    t.string "color"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "point", default: 100
    t.integer "charactor_id"
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vrs", force: :cascade do |t|
    t.integer "user_id"
    t.string "title"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
