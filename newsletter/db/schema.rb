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

ActiveRecord::Schema.define(:version => 20120606114913) do

  create_table "active_newsletters", :force => true do |t|
    t.integer  "newsletter_id"
    t.string   "overriding_subject"
    t.text     "overriding_description"
    t.string   "file_name"
    t.date     "start_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_newsletters", ["newsletter_id"], :name => "index_active_newsletters_on_newsletter_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["locked_by"], :name => "index_delayed_jobs_on_locked_by"

  create_table "invitations", :force => true do |t|
    t.integer  "sender_id"
    t.string   "recipient_email"
    t.string   "token"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "newsletter_subscriptions", :force => true do |t|
    t.integer  "subscriber_id"
    t.integer  "newsletter_id"
    t.boolean  "opt_in"
    t.datetime "last_submitted"
    t.boolean  "last_submitted_success"
    t.string   "submit_error",           :limit => 5000
    t.integer  "retry_count",                            :default => 3
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "newsletter_subscriptions", ["subscriber_id", "newsletter_id"], :name => "by_newsletter_subscriber"

  create_table "newsletters", :force => true do |t|
    t.string   "title"
    t.string   "subject"
    t.text     "description"
    t.string   "frequency",   :limit => 50
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "newsletters", ["title"], :name => "index_newsletters_on_title"

  create_table "subscribers", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "zipcode",             :limit => 10
    t.integer  "age",                 :limit => 3
    t.string   "gender",              :limit => 1
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state",               :limit => 2
    t.string   "phone_no",            :limit => 20
    t.string   "verification_status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
  end

  add_index "subscribers", ["email"], :name => "index_subscribers_on_email"

end
