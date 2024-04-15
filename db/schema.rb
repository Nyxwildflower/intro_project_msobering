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

ActiveRecord::Schema[7.1].define(version: 2024_04_15_024108) do
  create_table "artists", force: :cascade do |t|
    t.string "title"
    t.integer "birth_date"
    t.integer "death_date"
    t.text "description"
    t.integer "api_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "artworks", force: :cascade do |t|
    t.string "title"
    t.string "year"
    t.string "medium"
    t.string "place_of_origin"
    t.string "dimensions"
    t.text "description"
    t.string "alt_text"
    t.integer "api_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "artist_id"
    t.index ["artist_id"], name: "index_artworks_on_artist_id"
  end

  create_table "artworks_categories", id: false, force: :cascade do |t|
    t.integer "artwork_id", null: false
    t.integer "category_id", null: false
  end

  create_table "artworks_exhibitions", id: false, force: :cascade do |t|
    t.integer "artwork_id", null: false
    t.integer "exhibition_id", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exhibitions", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "gallery_title"
    t.datetime "exhibition_start"
    t.datetime "exhibition_end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
