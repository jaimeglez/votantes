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

ActiveRecord::Schema.define(version: 20170205191335) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "hstore"

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "messages", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "msg_type"
    t.string   "content_video"
    t.text     "content_text"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "sections", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name",           limit: 100
    t.uuid     "zone_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.uuid     "coordinator_id"
  end

  create_table "squares", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name",           limit: 100
    t.uuid     "section_id"
    t.uuid     "zone_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.uuid     "coordinator_id"
  end

  create_table "voter_documents", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.string   "attachment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "voters", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "full_name",              limit: 150
    t.string   "address"
    t.string   "electoral_number",       limit: 18
    t.string   "section"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.string   "latitude"
    t.string   "longitude"
    t.string   "phone_number"
    t.string   "social_network"
    t.integer  "role"
    t.boolean  "active"
    t.string   "provider",                           default: "email", null: false
    t.string   "uid",                                default: "",      null: false
    t.string   "encrypted_password",                 default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.json     "tokens"
    t.string   "email"
    t.uuid     "user_id"
  end

  add_index "voters", ["confirmation_token"], name: "index_voters_on_confirmation_token", unique: true, using: :btree
  add_index "voters", ["electoral_number"], name: "index_voters_on_electoral_number", unique: true, using: :btree
  add_index "voters", ["reset_password_token"], name: "index_voters_on_reset_password_token", unique: true, using: :btree

  create_table "zones", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name",           limit: 100
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.uuid     "coordinator_id"
  end

end
