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

ActiveRecord::Schema.define(version: 20170607151618) do

  create_table "cover_images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "doc_id"
    t.string   "title"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "isbn"
    t.string   "oclc"
    t.string   "lccn"
    t.string   "upc"
    t.string   "mbid"
    t.string   "artist_name"
    t.string   "album_name"
    t.string   "status"
    t.string   "doc_type"
    t.string   "last_fm_url"
    t.text     "response_data",      limit: 65535
    t.string   "service_name"
    t.datetime "last_search"
    t.boolean  "locked",                           default: false
    t.string   "ht_id"
    t.string   "issn"
    t.index ["album_name"], name: "index_cover_images_on_album_name", using: :btree
    t.index ["artist_name"], name: "index_cover_images_on_artist_name", using: :btree
    t.index ["created_at"], name: "index_cover_images_on_created_at", using: :btree
    t.index ["doc_id"], name: "index_cover_images_on_doc_id", using: :btree
    t.index ["id"], name: "index_cover_images_on_id", using: :btree
    t.index ["title"], name: "index_cover_images_on_title", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",               default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "encrypted_password",  default: "", null: false
    t.index ["email"], name: "index_users_on_email", using: :btree
  end

end
