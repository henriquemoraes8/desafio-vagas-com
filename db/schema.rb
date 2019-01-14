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

ActiveRecord::Schema.define(version: 2019_01_14_000709) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "applications", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "job_id"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_applications_on_job_id"
    t.index ["user_id"], name: "index_applications_on_user_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "description"
    t.string "company"
    t.string "title"
    t.bigint "location_id"
    t.integer "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_jobs_on_location_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_locations_on_name", unique: true
  end

  create_table "paths", force: :cascade do |t|
    t.bigint "location1_id"
    t.bigint "location2_id"
    t.integer "distance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location1_id"], name: "index_paths_on_location1_id"
    t.index ["location2_id"], name: "index_paths_on_location2_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "job_description"
    t.integer "level"
    t.bigint "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_users_on_location_id"
  end

  add_foreign_key "applications", "jobs"
  add_foreign_key "applications", "users"
  add_foreign_key "jobs", "locations"
  add_foreign_key "paths", "locations", column: "location1_id"
  add_foreign_key "paths", "locations", column: "location2_id"
  add_foreign_key "users", "locations"
end
