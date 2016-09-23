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

ActiveRecord::Schema.define(version: 20160923141309) do

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
    t.index ["doc_id"], name: "index_cover_images_on_doc_id", using: :btree
  end

end
