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

ActiveRecord::Schema.define(version: 20141103165445) do

  create_table "datasets", force: true do |t|
    t.float    "min_latitude"
    t.float    "max_latitude"
    t.float    "min_longitude"
    t.float    "max_longitude"
    t.float    "min_gain"
    t.float    "max_gain"
    t.float    "min_height"
    t.float    "max_height"
    t.integer  "quanity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dataset_url"
    t.string   "dataset_uid"
  end

end
