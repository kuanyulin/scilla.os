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

ActiveRecord::Schema.define(:version => 20100822040953) do

  create_table "accounts", :force => true do |t|
    t.integer  "account_type", :limit => 2
    t.integer  "subject_num",  :limit => 2
    t.string   "subject",      :limit => 80
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "description"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories_styles", :id => false, :force => true do |t|
    t.integer  "style_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", :force => true do |t|
    t.string   "name",           :limit => 80,                                               :null => false
    t.date     "birthdate"
    t.integer  "membership",     :limit => 2
    t.string   "email",          :limit => 100
    t.string   "mobile",         :limit => 20
    t.string   "phone",          :limit => 20
    t.string   "address"
    t.string   "bank",           :limit => 80
    t.string   "bank_account",   :limit => 20
    t.integer  "total_purchase", :limit => 7,   :precision => 7, :scale => 0, :default => 0
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "daily_revenues", :force => true do |t|
    t.date     "sale_date",                                                                :null => false
    t.integer  "revenue",        :limit => 7, :precision => 7, :scale => 0, :default => 0
    t.integer  "credit_card",    :limit => 7, :precision => 7, :scale => 0, :default => 0
    t.integer  "cash",           :limit => 7, :precision => 7, :scale => 0, :default => 0
    t.integer  "cash_depois",    :limit => 7, :precision => 7, :scale => 0, :default => 0
    t.integer  "reserve_cash",   :limit => 7, :precision => 7, :scale => 0, :default => 0
    t.integer  "total_discount", :limit => 7, :precision => 7, :scale => 0, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", :force => true do |t|
    t.date     "entry_date"
    t.string   "description"
    t.decimal  "credit",      :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "debit",       :precision => 12, :scale => 2, :default => 0.0
    t.integer  "account_id",                                                  :null => false
    t.integer  "journal_id",                                                  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "pair_id"
    t.integer  "style_id"
    t.decimal  "size",                       :precision => 3, :scale => 1
    t.integer  "list_price",    :limit => 7, :precision => 7, :scale => 0, :default => 0
    t.integer  "discount",      :limit => 7, :precision => 7, :scale => 0, :default => 0
    t.integer  "paid_amount",   :limit => 7, :precision => 7, :scale => 0, :default => 0
    t.integer  "percent_off",                                              :default => 0
    t.integer  "status"
    t.date     "purchase_date",                                                           :null => false
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "journals", :force => true do |t|
    t.date     "entry_date"
    t.string   "title"
    t.boolean  "balanced",                                    :default => false
    t.integer  "edited_by"
    t.decimal  "total_credit", :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "total_debit",  :precision => 12, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.integer  "customer_id"
    t.date     "purchase_date",                                                              :null => false
    t.integer  "total_list_price", :limit => 7, :precision => 7, :scale => 0, :default => 0
    t.integer  "total_discount",   :limit => 7, :precision => 7, :scale => 0, :default => 0
    t.integer  "extra_discount",   :limit => 7, :precision => 7, :scale => 0, :default => 0
    t.integer  "total_paid",       :limit => 7, :precision => 7, :scale => 0, :default => 0
    t.integer  "payment_type"
    t.integer  "status"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pairs", :force => true do |t|
    t.integer  "style_id",                                                :null => false
    t.integer  "refill_id",                                               :null => false
    t.decimal  "size",       :precision => 3, :scale => 1,                :null => false
    t.integer  "status",                                   :default => 0, :null => false
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prices", :force => true do |t|
    t.integer  "style_id",                                 :null => false
    t.decimal  "price",      :precision => 7, :scale => 2
    t.datetime "start_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "refills", :force => true do |t|
    t.date     "order_date"
    t.date     "arrive_date"
    t.boolean  "arrived",     :default => false, :null => false
    t.string   "description"
    t.integer  "made_by"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "sizes", :force => true do |t|
    t.decimal  "size",       :precision => 3, :scale => 1, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sizes_styles", :id => false, :force => true do |t|
    t.integer  "style_id",   :null => false
    t.integer  "size_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "styles", :force => true do |t|
    t.integer  "vendor_id",                                  :null => false
    t.string   "name",                                       :null => false
    t.string   "vendor_model",                               :null => false
    t.string   "at_model",                                   :null => false
    t.text     "spec"
    t.string   "picture1"
    t.string   "picture2"
    t.string   "picture3"
    t.string   "picture4"
    t.string   "thumbnail"
    t.text     "note"
    t.decimal  "cost",         :precision => 7, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "hashed_password"
    t.string   "salt"
    t.integer  "privilege",       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vendors", :force => true do |t|
    t.string   "name",         :null => false
    t.string   "address"
    t.string   "contact1"
    t.string   "contact2"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "fax"
    t.string   "bank_name"
    t.string   "bank_account"
    t.string   "tax_id"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
