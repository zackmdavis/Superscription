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

ActiveRecord::Schema.define(:version => 20131105191538) do

  create_table "entries", :force => true do |t|
    t.string   "title"
    t.string   "author"
    t.string   "url"
    t.datetime "datetime"
    t.text     "content"
    t.integer  "subscription_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.text     "description"
    t.string   "guid"
  end

  add_index "entries", ["subscription_id"], :name => "index_entries_on_subscription_id"
  add_index "entries", ["url"], :name => "index_entries_on_url"

  create_table "subscriptions", :force => true do |t|
    t.string   "url"
    t.string   "title"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "update_frequency"
    t.datetime "last_build_date"
  end

  create_table "user_subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "subscription_id"
    t.integer  "category_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "user_subscriptions", ["category_id"], :name => "index_user_subscriptions_on_category_id"
  add_index "user_subscriptions", ["subscription_id"], :name => "index_user_subscriptions_on_subscription_id"
  add_index "user_subscriptions", ["user_id"], :name => "index_user_subscriptions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "username",               :default => "", :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
