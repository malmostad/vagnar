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

ActiveRecord::Schema.define(version: 20171103142315) do

  create_table "admins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci" do |t|
    t.string "username"
    t.datetime "last_login_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_admins_on_username"
  end

  create_table "booking_periods", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci" do |t|
    t.date "starts_at"
    t.date "ends_at"
    t.datetime "booking_starts_at"
    t.datetime "booking_ends_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bookings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci" do |t|
    t.bigint "time_slot_id"
    t.bigint "company_id"
    t.bigint "place_id"
    t.bigint "booking_period_id"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_period_id"], name: "index_bookings_on_booking_period_id"
    t.index ["company_id"], name: "index_bookings_on_company_id"
    t.index ["place_id"], name: "index_bookings_on_place_id"
    t.index ["time_slot_id"], name: "index_bookings_on_time_slot_id"
  end

  create_table "companies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci" do |t|
    t.string "name"
    t.string "org_number"
    t.string "police_permit"
    t.date "permit_starts_at"
    t.date "permit_ends_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "places", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci" do |t|
    t.string "name"
    t.string "address"
    t.integer "east"
    t.integer "north"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sellers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci" do |t|
    t.string "snin_birthday"
    t.string "snin_extension"
    t.string "name"
    t.bigint "company_id"
    t.datetime "last_login_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_sellers_on_company_id"
    t.index ["snin_birthday", "snin_extension"], name: "index_sellers_on_snin_birthday_and_snin_extension", unique: true
  end

  create_table "settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci" do |t|
    t.string "key"
    t.string "human_name"
    t.string "value"
    t.index ["key"], name: "index_settings_on_key", unique: true
  end

  create_table "time_slots", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci" do |t|
    t.string "from"
    t.string "to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bookings", "companies"
  add_foreign_key "bookings", "places"
  add_foreign_key "bookings", "time_slots"
  add_foreign_key "sellers", "companies"
end
