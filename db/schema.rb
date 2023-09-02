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

ActiveRecord::Schema[7.0].define(version: 2023_08_31_160257) do
  create_table "accounts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "gl"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "branches", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "departments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "message"
    t.boolean "read", default: false
    t.bigint "user_id", null: false
    t.bigint "request_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_id"], name: "index_notifications_on_request_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "rejections", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "reason"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "request_id", null: false
    t.index ["request_id"], name: "index_rejections_on_request_id"
    t.index ["user_id"], name: "index_rejections_on_user_id"
  end

  create_table "requests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "amount", precision: 10
    t.bigint "account_id"
    t.bigint "requested_by_id"
    t.bigint "vetted_by_id"
    t.bigint "approved_by_id"
    t.bigint "cleared_by_id"
    t.bigint "paid_by_id"
    t.text "comment"
    t.text "narration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.integer "payment_type", default: 0
    t.integer "expense_type", default: 0
    t.timestamp "vetted_at"
    t.timestamp "approved_at"
    t.timestamp "cleared_at"
    t.timestamp "paid_at"
    t.string "trx_code"
    t.string "trf_account_name"
    t.bigint "trf_account_no"
    t.string "trf_bank_name"
    t.index ["account_id"], name: "index_requests_on_account_id"
    t.index ["approved_by_id"], name: "index_requests_on_approved_by_id"
    t.index ["cleared_by_id"], name: "index_requests_on_cleared_by_id"
    t.index ["paid_by_id"], name: "index_requests_on_paid_by_id"
    t.index ["requested_by_id"], name: "index_requests_on_requested_by_id"
    t.index ["vetted_by_id"], name: "index_requests_on_vetted_by_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "name", default: "", null: false
    t.integer "role", default: 0, null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "branch_id", null: false
    t.bigint "department_id", null: false
    t.index ["branch_id"], name: "index_users_on_branch_id"
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "notifications", "requests"
  add_foreign_key "notifications", "users"
  add_foreign_key "rejections", "requests"
  add_foreign_key "rejections", "users"
  add_foreign_key "requests", "accounts"
  add_foreign_key "requests", "users", column: "approved_by_id"
  add_foreign_key "requests", "users", column: "cleared_by_id"
  add_foreign_key "requests", "users", column: "paid_by_id"
  add_foreign_key "requests", "users", column: "requested_by_id"
  add_foreign_key "requests", "users", column: "vetted_by_id"
  add_foreign_key "users", "branches"
  add_foreign_key "users", "departments"
end
