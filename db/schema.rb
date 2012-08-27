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

ActiveRecord::Schema.define(:version => 20120827142622) do

  create_table "peers", :force => true do |t|
    t.string   "peer_id"
    t.string   "ip"
    t.string   "port"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "uploaded"
    t.string   "downloaded"
    t.string   "left"
    t.datetime "last_action_at"
    t.integer  "torrent_id"
  end

  create_table "torrents", :force => true do |t|
    t.string   "info_hash"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "name"
    t.string   "description"
  end

end
