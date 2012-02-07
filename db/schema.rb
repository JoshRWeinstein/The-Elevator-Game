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

ActiveRecord::Schema.define(:version => 20120207232609) do

  create_table "rides", :force => true do |t|
    t.string   "ip_address"
    t.integer  "session_id"
    t.float    "timetoclick"
    t.integer  "rows"
    t.integer  "columns"
    t.integer  "floor"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "big"
    t.integer  "config"
    t.integer  "last"
  end

  create_table "usersessions", :force => true do |t|
    t.integer  "ridecount"
    t.integer  "floors"
    t.float    "time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "config"
    t.string   "name"
  end

end
