class AddDemographicsToSurveyInstance < ActiveRecord::Migration
  def self.up
    add_column :survey_instances, :name_first, :string
    add_column :survey_instances, :name_last, :string
    add_column :survey_instances, :address1, :string
    add_column :survey_instances, :address2, :string
    add_column :survey_instances, :city, :string
    add_column :survey_instances, :state_id, :integer
    add_column :survey_instances, :zipcode, :string
    add_column :survey_instances, :phone, :string
    add_column :survey_instances, :dob, :date
  end

  def self.down
    remove_column :survey_instances, :name_first
    remove_column :survey_instances, :name_last
    remove_column :survey_instances, :address1
    remove_column :survey_instances, :address2
    remove_column :survey_instances, :city
    remove_column :survey_instances, :state_id
    remove_column :survey_instances, :zipcode
    remove_column :survey_instances, :phone
    remove_column :survey_instances, :dob
  end
end

