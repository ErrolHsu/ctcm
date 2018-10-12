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

ActiveRecord::Schema.define(version: 2018_10_12_165100) do

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

  create_table "admin_settings", force: :cascade do |t|
    t.bigint "admin_id"
    t.boolean "order_paid_mail", default: true
    t.boolean "order_cancel_mail", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_admin_settings_on_admin_id"
  end

  create_table "admins", force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cart_items", force: :cascade do |t|
    t.integer "product_id"
    t.integer "quantity"
    t.bigint "cart_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
  end

  create_table "carts", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id"
    t.string "product_name"
    t.integer "price"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "product_id"
    t.integer "variant_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "total"
    t.boolean "period"
    t.string "status"
    t.string "payment_status"
    t.string "shipping_status"
    t.integer "period_amount"
    t.string "period_type"
    t.integer "frequency"
    t.integer "exec_times"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "order_no"
    t.text "note"
    t.datetime "paid_at"
    t.string "merchant_trade_no"
    t.integer "duration"
    t.integer "shipping_rate"
    t.string "payment"
    t.boolean "paid", default: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "period_orders", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "order_id"
    t.integer "no"
    t.integer "amount"
    t.date "expected_date"
    t.string "status"
    t.boolean "paid"
    t.string "shipping_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "paid_at"
    t.index ["order_id"], name: "index_period_orders_on_order_id"
    t.index ["user_id"], name: "index_period_orders_on_user_id"
  end

  create_table "product_variants", force: :cascade do |t|
    t.bigint "product_id"
    t.string "weight"
    t.integer "price"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_variants_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "period_order_only", default: false
  end

  create_table "shipping_addresses", force: :cascade do |t|
    t.bigint "order_id"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "email"
    t.string "phone"
    t.index ["order_id"], name: "index_shipping_addresses_on_order_id"
  end

  create_table "trade_infos", force: :cascade do |t|
    t.bigint "order_id"
    t.integer "period_order_id"
    t.integer "rtn_code"
    t.string "merchant_trade_no"
    t.string "trade_no"
    t.integer "trade_amt"
    t.integer "amount"
    t.string "rtn_msg"
    t.jsonb "total_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_trade_infos_on_order_id"
    t.index ["period_order_id"], name: "index_trade_infos_on_period_order_id"
  end

  create_table "trials", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "address"
    t.string "message"
    t.string "product_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "executed", default: false
    t.string "status", default: "request"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.text "remote_avatar_url"
    t.string "facebook"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "admin_settings", "admins"
  add_foreign_key "cart_items", "carts"
  add_foreign_key "carts", "users"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "users"
  add_foreign_key "period_orders", "orders"
  add_foreign_key "period_orders", "users"
  add_foreign_key "product_variants", "products"
  add_foreign_key "shipping_addresses", "orders"
  add_foreign_key "trade_infos", "orders"
end
