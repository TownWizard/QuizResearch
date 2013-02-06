class RemoveSurveyIdFromQuizInstances < ForeignKeyMigration

  def self.up
    remove_foreign_key :quiz_instances, :survey_id
    remove_column :quiz_instances, :survey_id
  end

  def self.down
    add_column :quiz_instances, :survey_id, :integer
    add_foreign_key :quiz_instances, :survey_id, :surveys
  end

end
