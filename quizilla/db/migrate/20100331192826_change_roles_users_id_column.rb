class ChangeRolesUsersIdColumn < ActiveRecord::Migration
  def self.up
    remove_index :roles_users, :user_id
    rename_column :roles_users, :user_id, :partner_site_user_id
    add_index :roles_users, :partner_site_user_id
  end

  def self.down
    rename_column :roles_users, :partner_site_user_id, :user_id
    add_index :roles_users, :user_id
  end
end
