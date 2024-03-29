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

ActiveRecord::Schema.define(:version => 20111217083754) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "comments", :force => true do |t|
    t.integer  "user_id",          :null => false
    t.integer  "users_mission_id", :null => false
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"
  add_index "comments", ["users_mission_id"], :name => "index_comments_on_users_mission_id"

  create_table "missions", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "beginning"
    t.datetime "end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_socials", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "email"
    t.boolean  "just_social",        :default => false
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "birthdate"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users_missions", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "mission_id", :null => false
    t.string   "text"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_missions", ["mission_id"], :name => "index_users_missions_on_mission_id"
  add_index "users_missions", ["user_id"], :name => "index_users_missions_on_user_id"

end
