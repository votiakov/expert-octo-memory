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

ActiveRecord::Schema.define(version: 20171003165556) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "basket_items", force: :cascade do |t|
    t.string "resource_type"
    t.bigint "resource_id"
    t.bigint "basket_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity"
    t.index ["basket_id"], name: "index_basket_items_on_basket_id"
    t.index ["resource_type", "resource_id"], name: "index_basket_items_on_resource_type_and_resource_id"
  end

  create_table "baskets", force: :cascade do |t|
    t.boolean "checked_out", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.decimal "price", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "promotion_items", force: :cascade do |t|
    t.bigint "promotion_id"
    t.bigint "item_id"
    t.integer "quantity", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_promotion_items_on_item_id"
    t.index ["promotion_id"], name: "index_promotion_items_on_promotion_id"
  end

  create_table "promotions", force: :cascade do |t|
    t.string "kind", null: false
    t.float "value"
    t.string "code"
    t.boolean "can_combine", default: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
