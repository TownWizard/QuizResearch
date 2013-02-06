class AddFacebookFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :gender,               :string
    add_column :users, :profile_link,         :string
    add_column :users, :birthday,             :date
  end

  def self.down
    remove_column :users, :gender
    remove_column :users, :profile_link
    remove_column :users, :birthday
  end
end
