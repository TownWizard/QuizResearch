class CreateSurveyInstances < ActiveRecord::Migration
  def self.up
    create_table :survey_instances do |t|

      t.integer :survey_id
      t.string :customer_email
      t.integer :store_code
      t.integer :survey_code

      t.timestamps
    end
  end

  def self.down
    drop_table :survey_instances
  end
end
