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

ActiveRecord::Schema.define(version: 20170811232905) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "uuid-ossp"

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
    t.hstore   "receivers"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "notes", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.text     "note",       null: false
    t.integer  "note_type",  null: false
    t.uuid     "voter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "notes", ["note_type"], name: "index_notes_on_note_type", using: :btree
  add_index "notes", ["voter_id"], name: "index_notes_on_voter_id", using: :btree

  create_table "sections", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name",           limit: 100
    t.uuid     "zone_id"
    t.uuid     "coordinator_id"
    t.boolean  "active",                     default: true
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "sections", ["active"], name: "index_sections_on_active", using: :btree
  add_index "sections", ["coordinator_id"], name: "index_sections_on_coordinator_id", using: :btree
  add_index "sections", ["zone_id"], name: "index_sections_on_zone_id", using: :btree

  create_table "squares", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name",           limit: 100
    t.uuid     "section_id"
    t.uuid     "coordinator_id"
    t.boolean  "active",                     default: true
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "squares", ["active"], name: "index_squares_on_active", using: :btree
  add_index "squares", ["coordinator_id"], name: "index_squares_on_coordinator_id", using: :btree
  add_index "squares", ["section_id"], name: "index_squares_on_section_id", using: :btree

  create_table "voter_documents", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.string   "attachment"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "imported",   default: false
  end

  create_table "voters", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "electoral_number",       default: ""
    t.string   "latitude"
    t.string   "longitude"
    t.string   "phone_number"
    t.string   "social_network"
    t.integer  "role"
    t.string   "email",                  default: ""
    t.boolean  "active",                 default: true
    t.uuid     "square_id"
    t.string   "audio"
    t.string   "provider",               default: "email"
    t.string   "uid",                    default: ""
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.json     "tokens"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.uuid     "promoter_id"
    t.string   "name"
    t.string   "f_last_name"
    t.string   "s_last_name"
    t.string   "birth_date"
    t.string   "gender"
    t.string   "street"
    t.string   "ext_num"
    t.string   "int_num"
    t.string   "neighborhood"
    t.uuid     "added_by_id"
    t.string   "device_token"
  end

  add_index "voters", ["active"], name: "index_voters_on_active", using: :btree
  add_index "voters", ["confirmation_token"], name: "index_voters_on_confirmation_token", unique: true, using: :btree
  add_index "voters", ["reset_password_token"], name: "index_voters_on_reset_password_token", unique: true, using: :btree
  add_index "voters", ["role"], name: "index_voters_on_role", using: :btree
  add_index "voters", ["square_id"], name: "index_voters_on_square_id", using: :btree

  create_table "zones", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name",           limit: 100
    t.uuid     "coordinator_id"
    t.boolean  "active",                     default: true
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "zones", ["active"], name: "index_zones_on_active", using: :btree
  add_index "zones", ["coordinator_id"], name: "index_zones_on_coordinator_id", using: :btree

end
