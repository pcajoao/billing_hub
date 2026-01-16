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

ActiveRecord::Schema[7.1].define(version: 2026_01_15_233008) do
  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "doc_type"
    t.string "doc_number"
    t.string "external_id"
    t.string "global_id"
    t.string "gateway_id"
    t.integer "tenant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["global_id"], name: "index_customers_on_global_id"
    t.index ["tenant_id", "external_id"], name: "index_customers_on_tenant_id_and_external_id", unique: true
    t.index ["tenant_id"], name: "index_customers_on_tenant_id"
  end

  create_table "gateway_events", force: :cascade do |t|
    t.string "gateway_id"
    t.string "event_type"
    t.json "payload"
    t.datetime "processed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoice_items", force: :cascade do |t|
    t.string "description"
    t.integer "amount_cents"
    t.integer "quantity"
    t.string "item_type"
    t.integer "invoice_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.string "status"
    t.datetime "due_date"
    t.integer "total_amount_cents"
    t.string "gateway_id"
    t.string "checkout_url"
    t.integer "customer_id", null: false
    t.integer "product_id", null: false
    t.integer "subscription_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_invoices_on_customer_id"
    t.index ["product_id"], name: "index_invoices_on_product_id"
    t.index ["subscription_id"], name: "index_invoices_on_subscription_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "gateway_id"
    t.string "brand"
    t.string "last4"
    t.string "exp_month"
    t.string "exp_year"
    t.string "holder_name"
    t.boolean "is_default", default: false
    t.integer "customer_id", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_payment_methods_on_customer_id"
    t.index ["discarded_at"], name: "index_payment_methods_on_discarded_at"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "api_key"
    t.string "webhook_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_key"], name: "index_products_on_api_key", unique: true
    t.index ["code"], name: "index_products_on_code", unique: true
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "plan_id"
    t.string "status"
    t.datetime "current_period_end"
    t.string "gateway_id"
    t.integer "amount_cents"
    t.string "cron_expression"
    t.integer "customer_id", null: false
    t.integer "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_subscriptions_on_customer_id"
    t.index ["product_id"], name: "index_subscriptions_on_product_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.string "name"
    t.string "external_id"
    t.integer "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "external_id"], name: "index_tenants_on_product_id_and_external_id", unique: true
    t.index ["product_id"], name: "index_tenants_on_product_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "gateway_id"
    t.string "status"
    t.string "kind"
    t.integer "amount_cents"
    t.string "gateway_response_code"
    t.text "gateway_response_message"
    t.integer "invoice_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_transactions_on_invoice_id"
  end

  add_foreign_key "customers", "tenants"
  add_foreign_key "invoice_items", "invoices"
  add_foreign_key "invoices", "customers"
  add_foreign_key "invoices", "products"
  add_foreign_key "invoices", "subscriptions"
  add_foreign_key "payment_methods", "customers"
  add_foreign_key "subscriptions", "customers"
  add_foreign_key "subscriptions", "products"
  add_foreign_key "tenants", "products"
  add_foreign_key "transactions", "invoices"
end
