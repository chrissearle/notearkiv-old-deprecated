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

ActiveRecord::Schema.define(:version => 20110226195942) do

  create_table "composers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "evensongs", :force => true do |t|
    t.string   "title"
    t.integer  "psalm"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "doc_url"
    t.integer  "composer_id"
    t.integer  "genre_id"
    t.string   "music_url"
    t.string   "soloists"
    t.text     "comment"
  end

  add_index "evensongs", ["composer_id"], :name => "index_evensongs_on_composer_id"
  add_index "evensongs", ["genre_id"], :name => "index_evensongs_on_genre_id"

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "import_logs", :force => true do |t|
    t.string   "field"
    t.string   "message"
    t.integer  "item"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instruments", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.integer  "note_id"
    t.integer  "evensong_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "links", ["evensong_id"], :name => "index_links_on_evensong_id"
  add_index "links", ["note_id"], :name => "index_links_on_note_id"

  create_table "note_language_assignments", :force => true do |t|
    t.integer  "note_id"
    t.integer  "language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "note_language_assignments", ["language_id"], :name => "index_note_language_assignments_on_language_id"
  add_index "note_language_assignments", ["note_id"], :name => "index_note_language_assignments_on_note_id"

  create_table "notes", :force => true do |t|
    t.integer  "item"
    t.string   "title"
    t.integer  "count_originals"
    t.integer  "count_copies"
    t.integer  "count_instrumental"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "voice"
    t.string   "doc_url"
    t.integer  "composer_id"
    t.integer  "genre_id"
    t.integer  "period_id"
    t.string   "instrument"
    t.string   "music_url"
    t.string   "soloists"
    t.text     "comment"
  end

  add_index "notes", ["composer_id"], :name => "index_notes_on_composer_id"
  add_index "notes", ["genre_id"], :name => "index_notes_on_genre_id"
  add_index "notes", ["period_id"], :name => "index_notes_on_period_id"

  create_table "periods", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "session_caches", :force => true do |t|
    t.string   "serialized_session"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_role_assignments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_role_assignments", ["role_id"], :name => "index_user_role_assignments_on_role_id"
  add_index "user_role_assignments", ["user_id"], :name => "index_user_role_assignments_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "persistence_token"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "onetime"
    t.string   "name"
  end

end
