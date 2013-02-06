class RevertIdColumnChangeInRolesUsers < ActiveRecord::Migration
  def self.up
    rename_column :roles_users, :partner_site_user_id, :user_id
  end

  def self.down
    rename_column :roles_users, :user_id, :partner_site_user_id
  end
end
