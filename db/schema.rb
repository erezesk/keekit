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

ActiveRecord::Schema.define(:version => 20130429115147) do

  create_table "advertisements", :force => true do |t|
    t.string   "name"
    t.boolean  "active",        :default => true
    t.integer  "views",         :default => 0
    t.integer  "ratings_count", :default => 0
    t.float    "rating",        :default => 0.0
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "content_link"
    t.string   "ad_type"
    t.integer  "user_id"
  end

  create_table "ratings", :force => true do |t|
    t.integer  "value"
    t.integer  "advertisement_id"
    t.integer  "user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

end
