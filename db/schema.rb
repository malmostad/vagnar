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

ActiveRecord::Schema.define(version: 20171013141336) do

  create_table "admin_accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci" do |t|
    t.bigint "user_id"
    t.index ["user_id"], name: "index_admin_accounts_on_user_id", unique: true
  end

  create_table "seller_accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci" do |t|
    t.bigint "user_id"
    t.index ["user_id"], name: "index_seller_accounts_on_user_id", unique: true
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci" do |t|
    t.string "username"
    t.string "role"
    t.string "last_login_at"
    t.string "ip_address"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "admin_accounts", "users"
  add_foreign_key "seller_accounts", "users"
end
