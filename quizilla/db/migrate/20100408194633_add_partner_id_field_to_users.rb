class AddPartnerIdFieldToUsers < ForeignKeyMigration

  def self.up
    add_column :users, :partner_id, :integer, :default => nil
    add_foreign_key :users, :partner_id, :partners
  end

  def self.down
    remove_foreign_key :users, :partner_id
    remove_column :users, :partner_id
  end
  
end
