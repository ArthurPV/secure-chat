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

ActiveRecord::Schema[7.2].define(version: 2025_04_02_031244) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
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

  create_table "messages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "content", null: false
    t.bigint "user_conversation_id", null: false
    t.bigint "user_id", null: false
    t.index ["user_conversation_id"], name: "index_messages_on_user_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "user_contact_requests", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "contacted_id", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_contact_requests_on_user_id"
  end

  create_table "user_contacteds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_contact_id", null: false
    t.bigint "user_id", null: false
    t.index ["user_contact_id"], name: "index_user_contacteds_on_user_contact_id"
    t.index ["user_id"], name: "index_user_contacteds_on_user_id"
  end

  create_table "user_contacts", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_conversation_keys", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "public_key", null: false
    t.string "private_key", null: false
    t.bigint "user_conversation_id", null: false
    t.index ["user_conversation_id"], name: "index_user_conversation_keys_on_user_conversation_id"
  end

  create_table "user_conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
  end

  create_table "user_conversations_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "user_conversation_id", null: false
    t.index ["user_id", "user_conversation_id"], name: "idx_on_user_id_user_conversation_id_a9cca56b72"
  end

  create_table "user_jtis", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.bigint "user_id", null: false
    t.index ["jti"], name: "index_user_jtis_on_jti", unique: true
    t.index ["user_id"], name: "index_user_jtis_on_user_id"
  end

  create_table "user_keys", force: :cascade do |t|
    t.string "public_key", null: false
    t.string "private_key", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_keys_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.string "username", null: false
    t.string "phone_number", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "messages", "user_conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "user_contact_requests", "users"
  add_foreign_key "user_contacteds", "user_contacts"
  add_foreign_key "user_contacteds", "users"
  add_foreign_key "user_conversation_keys", "user_conversations"
  add_foreign_key "user_jtis", "users"
  add_foreign_key "user_keys", "users"
end
