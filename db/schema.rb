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

ActiveRecord::Schema[7.1].define(version: 2025_08_08_132924) do
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

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "parent_id"
    t.string "slug"
    t.boolean "active", default: true
    t.integer "sort_order", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "slug_count", default: 0
    t.index ["active"], name: "index_categories_on_active"
    t.index ["parent_id"], name: "index_categories_on_parent_id"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", null: false
    t.decimal "price_at_purchase", precision: 10, scale: 2, null: false
    t.decimal "subtotal", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id", "product_id"], name: "index_order_items_on_order_id_and_product_id", unique: true
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "order_number", null: false
    t.datetime "order_date", default: -> { "CURRENT_TIMESTAMP" }
    t.string "status", default: "pending"
    t.decimal "subtotal", precision: 10, scale: 2
    t.decimal "tax_amount", precision: 10, scale: 2
    t.decimal "shipping_cost", precision: 10, scale: 2
    t.decimal "total_amount", precision: 10, scale: 2
    t.string "shipping_first_name"
    t.string "shipping_last_name"
    t.string "shipping_address"
    t.string "shipping_city"
    t.string "shipping_province"
    t.string "shipping_postal_code"
    t.string "shipping_country"
    t.string "shipping_phone"
    t.string "billing_first_name"
    t.string "billing_last_name"
    t.string "billing_address"
    t.string "billing_city"
    t.string "billing_province"
    t.string "billing_postal_code"
    t.string "billing_country"
    t.string "billing_phone"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_date"], name: "index_orders_on_order_date"
    t.index ["order_number"], name: "index_orders_on_order_number", unique: true
    t.index ["status"], name: "index_orders_on_status"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
    t.text "content"
    t.text "meta_description"
    t.boolean "published", default: true
    t.integer "sort_order", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["published"], name: "index_pages_on_published"
    t.index ["slug"], name: "index_pages_on_slug", unique: true
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "payment_method"
    t.string "payment_status", default: "pending"
    t.decimal "amount", precision: 10, scale: 2
    t.string "transaction_id"
    t.text "gateway_response"
    t.datetime "payment_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payments_on_order_id"
    t.index ["payment_status"], name: "index_payments_on_payment_status"
    t.index ["transaction_id"], name: "index_payments_on_transaction_id", unique: true
  end

  create_table "product_prices", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "start_date", null: false
    t.datetime "end_date"
    t.boolean "is_active", default: true
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_active"], name: "index_product_prices_on_is_active"
    t.index ["product_id", "start_date"], name: "index_product_prices_on_product_id_and_start_date"
    t.index ["product_id"], name: "index_product_prices_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.text "short_description"
    t.decimal "current_price", precision: 10, scale: 2
    t.decimal "compare_at_price", precision: 10, scale: 2
    t.integer "stock_quantity", default: 0
    t.bigint "category_id", null: false
    t.string "sku", null: false
    t.decimal "weight", precision: 8, scale: 3
    t.string "dimensions"
    t.boolean "is_active", default: true
    t.boolean "featured", default: false
    t.boolean "on_sale", default: false
    t.datetime "sale_start_date"
    t.datetime "sale_end_date"
    t.string "slug"
    t.text "sustainability_info"
    t.string "material"
    t.string "origin_country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "slug_count", default: 0
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["featured"], name: "index_products_on_featured"
    t.index ["is_active"], name: "index_products_on_is_active"
    t.index ["on_sale"], name: "index_products_on_on_sale"
    t.index ["sku"], name: "index_products_on_sku", unique: true
    t.index ["slug"], name: "index_products_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.text "address"
    t.string "city"
    t.string "province"
    t.string "postal_code"
    t.string "country", default: "Canada"
    t.integer "role", default: 0
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "users"
  add_foreign_key "payments", "orders"
  add_foreign_key "product_prices", "products"
  add_foreign_key "products", "categories"
end
