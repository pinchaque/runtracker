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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130707000845) do

  create_table "activities", :force => true do |t|
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "activity_type_id", :null => false
    t.integer  "athlete_id",       :null => false
    t.string   "name",             :null => false
    t.datetime "start_time",       :null => false
    t.string   "uid"
  end

  add_index "activities", ["athlete_id"], :name => "index_activities_on_athlete_id"
  add_index "activities", ["uid"], :name => "index_activities_on_uid", :unique => true

  create_table "activity_laps", :force => true do |t|
    t.integer  "activity_id", :null => false
    t.datetime "start_time",  :null => false
  end

  add_index "activity_laps", ["activity_id"], :name => "index_activity_laps_on_activity_id"

  create_table "activity_points", :force => true do |t|
    t.integer  "activity_lap_id", :null => false
    t.datetime "time",            :null => false
    t.float    "latitude",        :null => false
    t.float    "longitude",       :null => false
    t.float    "elevation"
    t.float    "accuracy"
    t.float    "temperature"
    t.integer  "heart_rate"
  end

  add_index "activity_points", ["activity_lap_id"], :name => "index_activity_points_on_activity_lap_id"

  create_table "activity_types", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "athletes", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name",       :null => false
  end

end
