class AddPartnerSiteUsers < ActiveRecord::Migration
  def self.up
    create_table "partner_site_users",    :force => true do |t|
      t.string   "name_first",            :limit => 25,  :default => ""
      t.string   "name_last",             :limit => 25,  :default => ""
      t.string   "email",                 :limit => 100
      t.string   "crypted_password",      :limit => 128, :default => "", :null => false
      t.string   "salt",                  :limit => 128, :default => "", :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "last_login_at"
      t.string   "remember_token",        :limit => 40
      t.datetime "remember_token_expires_at"
      t.integer  "partner_id"
      t.string   "persistence_token"
      t.string   "perishable_token"
      t.integer  "login_count",           :default => 0
      t.integer  "failed_login_count",    :default => 0
      t.datetime "last_request_at"
      t.datetime "current_login_at"
      t.string   "current_login_ip"
      t.string   "last_login_ip"
    end
  end

  def self.down
    drop_table "partner_site_users"
  end
end
