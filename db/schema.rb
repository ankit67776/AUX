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

ActiveRecord::Schema[8.0].define(version: 2025_03_28_004956) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ad_implementations", force: :cascade do |t|
    t.bigint "ad_unit_id", null: false
    t.bigint "publisher_site_id", null: false
    t.string "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ad_unit_id"], name: "index_ad_implementations_on_ad_unit_id"
    t.index ["publisher_site_id"], name: "index_ad_implementations_on_publisher_site_id"
  end

  create_table "ad_performances", force: :cascade do |t|
    t.bigint "ad_implementation_id", null: false
    t.integer "impressions"
    t.integer "clicks"
    t.decimal "revenue"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ad_implementation_id"], name: "index_ad_performances_on_ad_implementation_id"
  end

  create_table "ad_units", force: :cascade do |t|
    t.string "name"
    t.string "ad_type"
    t.decimal "price"
    t.bigint "advertiser_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "media"
    t.string "target_url"
    t.string "size"
    t.index ["advertiser_id"], name: "index_ad_units_on_advertiser_id"
  end

  create_table "advertisers", force: :cascade do |t|
    t.string "name"
    t.string "contact_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "company_name"
    t.string "website"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_advertisers_on_user_id", unique: true
  end

  create_table "publisher_sites", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.bigint "publisher_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publisher_id"], name: "index_publisher_sites_on_publisher_id"
  end

  create_table "publishers", force: :cascade do |t|
    t.string "name"
    t.string "contact_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "google_uid"
    t.string "google_token"
    t.string "google_refresh_token"
    t.string "uid"
    t.string "provider"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "ad_implementations", "ad_units"
  add_foreign_key "ad_implementations", "publisher_sites"
  add_foreign_key "ad_performances", "ad_implementations"
  add_foreign_key "ad_units", "advertisers"
  add_foreign_key "advertisers", "users"
  add_foreign_key "publisher_sites", "publishers"
end
