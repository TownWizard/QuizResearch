class AddColumnsToSurveyInstance < ActiveRecord::Migration
  def self.up
    add_column :survey_instances, :year_of_birth, :integer, :limit => 2
    add_column :survey_instances, :register_number, :string, :limit => 25
    add_column :survey_instances, :cashier_number, :string, :limit => 25
  end

  def self.down
    remove_column :survey_instances, :year_of_birth
    remove_column :survey_instances, :register_number
    remove_column :survey_instances, :cashier_number
  end
end

