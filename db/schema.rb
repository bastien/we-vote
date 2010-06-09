# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100607205035) do

  create_table "delegated_votes", :force => true do |t|
    t.integer  "user_id"
    t.float    "current_value"
    t.float    "last_increment"
    t.float    "last_value"
    t.boolean  "affected",       :default => true
    t.boolean  "last_affected",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delegations", :force => true do |t|
    t.integer  "delegatee_id"
    t.integer  "delegated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
