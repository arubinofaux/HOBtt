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

ActiveRecord::Schema.define(:version => 20121009221448) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "peers", :force => true do |t|
    t.string   "peer_id"
    t.string   "ip"
    t.integer  "port"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "uploaded",       :limit => 8
    t.integer  "downloaded",     :limit => 8
    t.integer  "leftt",          :limit => 8
    t.datetime "last_action_at"
    t.integer  "torrent_id"
  end

  create_table "torrent_files", :force => true do |t|
    t.string   "name"
    t.integer  "size",        :limit => 8
    t.string   "filename"
    t.integer  "files_count"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "torrent_id"
  end

  create_table "torrents", :force => true do |t|
    t.string   "info_hash"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "name"
    t.string   "description"
    t.integer  "completed",   :default => 0
  end

end
