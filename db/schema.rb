# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_12_24_010026) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "permission_logs", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.text "description", null: false
    t.text "group_name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "created_by", limit: 200, null: false
    t.string "updated_by", limit: 200, null: false
    t.index ["name"], name: "permissions_idx01", unique: true
  end

  create_table "role_logs", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
  end

  create_table "role_permission_logs", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
  end

  create_table "role_permissions", force: :cascade do |t|
    t.integer "role_id"
    t.integer "permission_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "created_by", limit: 200, null: false
    t.string "updated_by", limit: 200, null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", limit: 30, null: false
    t.text "description", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "created_by", limit: 200, null: false
    t.string "updated_by", limit: 200, null: false
    t.index ["name"], name: "roles_idx01", unique: true
  end

  create_table "store_constant_logs", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
  end

  create_table "store_constants", force: :cascade do |t|
    t.string "name", limit: 30, null: false
    t.text "description", null: false
    t.decimal "constant_value", precision: 10, scale: 2, null: false
    t.integer "archived", limit: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "created_by", limit: 200, null: false
    t.string "updated_by", limit: 200, null: false
    t.index ["name"], name: "store_constants_idx01", unique: true
  end

  create_table "store_type_logs", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
  end

  create_table "store_types", force: :cascade do |t|
    t.string "name", limit: 100
    t.integer "archived", limit: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "created_by", limit: 200, null: false
    t.string "updated_by", limit: 200, null: false
  end

  create_table "tbl_item_logs", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
  end

  create_table "tbl_items", force: :cascade do |t|
    t.string "item_number", limit: 20, null: false
    t.string "item_product", limit: 200, null: false
    t.string "finished_size", limit: 200
    t.decimal "setup_price", precision: 10, scale: 2, null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.integer "include_in_report", limit: 2
    t.integer "archived", limit: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "lock_version"
    t.string "created_by", limit: 200, null: false
    t.string "updated_by", limit: 200, null: false
    t.index ["item_number"], name: "tbl_items_idx01", unique: true
  end

  create_table "tbl_store_logs", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
  end

  create_table "tbl_stores", force: :cascade do |t|
    t.bigint "store_num", null: false
    t.integer "store_type_id"
    t.string "address", limit: 100
    t.string "city", limit: 50, null: false
    t.bigint "postcode", null: false
    t.string "state_region", limit: 20, null: false
    t.string "status", limit: 100, null: false
    t.string "phone_num", limit: 100
    t.string "district_manager", limit: 100
    t.string "dm_contact_num", limit: 100
    t.integer "is_halal", limit: 2, null: false
    t.integer "is_cafe", limit: 2, null: false
    t.integer "num_of_drivethru", limit: 2, null: false
    t.integer "internal_digital", limit: 2
    t.integer "drive_thru_digital", limit: 2
    t.integer "multiplier", limit: 2
    t.decimal "setup_price", precision: 10, scale: 2
    t.integer "archived", limit: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "lock_version"
    t.string "created_by", limit: 200, null: false
    t.string "updated_by", limit: 200, null: false
    t.index ["state_region"], name: "tbl_stores_idx2"
    t.index ["store_num"], name: "tbl_stores_idx0"
    t.index ["store_type_id"], name: "tbl_stores_idx1"
  end

  create_table "user_role_location_logs", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
  end

  create_table "user_role_locations", force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
    t.date "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "created_by", limit: 200, null: false
    t.string "updated_by", limit: 200, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", limit: 100, null: false
    t.string "last_name", limit: 100, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "password_changed_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.integer "approved", limit: 2, default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "views", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_views_on_email", unique: true
    t.index ["reset_password_token"], name: "index_views_on_reset_password_token", unique: true
  end

  add_foreign_key "role_permissions", "permissions"
  add_foreign_key "role_permissions", "roles"
  add_foreign_key "tbl_stores", "store_types"
  add_foreign_key "user_role_locations", "roles"
  add_foreign_key "user_role_locations", "users"
end
