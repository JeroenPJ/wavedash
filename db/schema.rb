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

ActiveRecord::Schema.define(version: 2019_01_05_122205) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
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
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "street"
    t.string "postal_code"
    t.string "city"
    t.string "province"
    t.string "country"
    t.bigint "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.index ["order_id"], name: "index_addresses_on_order_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", default: ""
    t.text "description", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "garments", force: :cascade do |t|
    t.string "name", default: ""
    t.text "description", default: ""
    t.integer "euros", default: 0
    t.integer "cents", default: 0
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_garments_on_category_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "garment_id"
    t.bigint "order_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "size"
    t.index ["garment_id"], name: "index_order_items_on_garment_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "paid_at"
  end

  create_table "taps", force: :cascade do |t|
    t.string "identifier"
    t.integer "taps", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "addresses", "orders"
  add_foreign_key "garments", "categories"
  add_foreign_key "order_items", "garments"
  add_foreign_key "order_items", "orders"
end
