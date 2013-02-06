class DropSurveyIdFromSurveyInstances < ForeignKeyMigration
  def self.up
    #remove_foreign_key :survey_instances, :survey_id
    remove_column :survey_instances, :survey_id
  end

  def self.down
    add_column :survey_instances, :survey_id, :integer
    #add_foreign_key :survey_instances, :survey_id, :surveys
  end
end
