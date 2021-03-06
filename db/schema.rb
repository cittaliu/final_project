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

ActiveRecord::Schema.define(version: 20170123013307) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string   "linkedin_id"
    t.string   "kind"
    t.string   "name"
    t.string   "linkedin_url"
    t.string   "industry"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "size"
    t.string   "website"
    t.string   "description"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "linkedin_url"
    t.string   "position"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["company_id"], name: "index_contacts_on_company_id", using: :btree
  end

  create_table "openings", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "name"
    t.string   "description"
    t.boolean  "status"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["company_id"], name: "index_openings_on_company_id", using: :btree
  end

  create_table "opportunities", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "opening_id"
    t.string   "status"
    t.float    "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["opening_id"], name: "index_opportunities_on_opening_id", using: :btree
    t.index ["user_id"], name: "index_opportunities_on_user_id", using: :btree
  end

  create_table "tokens", force: :cascade do |t|
    t.string   "access_token"
    t.string   "refresh_token"
    t.datetime "expires_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "usercontacts", force: :cascade do |t|
    t.integer  "contact_id"
    t.integer  "user_id"
    t.string   "summary"
    t.string   "location"
    t.string   "start"
    t.string   "end"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["contact_id"], name: "index_usercontacts_on_contact_id", using: :btree
    t.index ["user_id"], name: "index_usercontacts_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
