class AddPartnerSiteToQuizInstances < ForeignKeyMigration

  def self.up
    add_column :quiz_instances, :partner_site_id, :integer
  end

  def self.down
    remove_column :quiz_instances, :partner_site_id
  end
end
