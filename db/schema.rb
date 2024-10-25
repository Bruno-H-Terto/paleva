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

ActiveRecord::Schema[7.2].define(version: 2024_10_24_214548) do
  create_table "addresses", force: :cascade do |t|
    t.string "street", null: false
    t.integer "number", null: false
    t.string "district", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip_code", null: false
    t.string "complement"
    t.string "user_type", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_type", "user_id"], name: "index_addresses_on_user"
  end

  create_table "business_hours", force: :cascade do |t|
    t.integer "day_of_week", null: false
    t.integer "status", default: 0
    t.string "open_time"
    t.string "close_time"
    t.integer "restaurant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_business_hours_on_restaurant_id"
  end

  create_table "restaurant_owners", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "individual_tax_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "surname", null: false
    t.index ["email"], name: "index_restaurant_owners_on_email", unique: true
    t.index ["reset_password_token"], name: "index_restaurant_owners_on_reset_password_token", unique: true
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "name", null: false
    t.string "brand_name", null: false
    t.string "register_number", null: false
    t.string "comercial_phone", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "restaurant_owner_id", null: false
    t.string "code", null: false
    t.index ["restaurant_owner_id"], name: "index_restaurants_on_restaurant_owner_id"
  end

  add_foreign_key "business_hours", "restaurants"
  add_foreign_key "restaurants", "restaurant_owners"
end
