# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160322011144) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.text     "board",                     array: true
    t.text     "fog",                       array: true
    t.integer  "size_x"
    t.integer  "size_y"
    t.integer  "bombs"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "winner_uuid"
    t.integer  "winner_score"
  end

  add_index "games", ["user_id"], name: "index_games_on_user_id", using: :btree
  add_index "games", ["winner_uuid"], name: "index_games_on_winner_uuid", using: :btree

  create_table "users", force: :cascade do |t|
    t.text     "uuid"
    t.text     "status",     default: "offline"
    t.boolean  "online",     default: false,     null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "users", ["online"], name: "index_users_on_online", using: :btree
  add_index "users", ["status"], name: "index_users_on_status", using: :btree
  add_index "users", ["uuid"], name: "index_users_on_uuid", using: :btree

end
