class AddProviderUserDetailToSurveyInstance < ActiveRecord::Migration
  def self.up
    add_column :survey_instances, :state, :string, :limit => 25
    add_column :survey_instances, :gender, :string, :limit => 25
    add_column :survey_instances, :provider, :string, :limit => 25
    add_column :survey_instances, :uid, :string
  end

  def self.down
    remove_column :survey_instances, :state
    remove_column :survey_instances, :gender
    remove_column :survey_instances, :provider
    remove_column :survey_instances, :uid
  end
end
