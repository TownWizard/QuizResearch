class CreateAuthorizations < ActiveRecord::Migration
  def self.up
    create_table :authorizations do |t|
      t.string :provider
      t.string :uid
      t.integer :survey_instance_id

      t.timestamps
    end
  end

  def self.down
    drop_table :authorizations
  end
end
