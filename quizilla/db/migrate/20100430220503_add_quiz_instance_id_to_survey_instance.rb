class AddQuizInstanceIdToSurveyInstance < ForeignKeyMigration

  def self.up
    add_column :survey_instances, :quiz_instance_id, :integer
    add_foreign_key :survey_instances, :quiz_instance_id, :quiz_instances
  end

  def self.down
    remove_foreign_key :survey_instances, :quiz_instance_id
    remove_column :survey_instances, :quiz_instance_id
  end
  
end