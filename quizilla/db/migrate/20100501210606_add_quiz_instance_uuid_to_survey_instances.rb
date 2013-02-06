class AddQuizInstanceUuidToSurveyInstances < ActiveRecord::Migration
  def self.up
    add_column :survey_instances, :quiz_instance_uuid, :string
  end

  def self.down
    remove_column :survey_instances, :quiz_instance_uuid
  end
end
