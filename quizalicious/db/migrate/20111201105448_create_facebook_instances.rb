class CreateFacebookInstances < ActiveRecord::Migration
  def self.up
    create_table :facebook_instances do |t|
      t.integer     :facebook_quiz_id
      t.integer     :quiz_instance_id
      t.string      :quiz_instance_uuid
      t.integer     :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :facebook_instances
  end
end
