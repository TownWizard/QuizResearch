class CreateSubscribers < ActiveRecord::Migration
  def self.up
    create_table :subscribers do |t|
      t.string  :first_name
      t.string  :last_name
      t.string  :email
      t.string  :zipcode,             :limit => 10
      t.integer :age,                 :limit => 3
      t.string  :gender,              :limit => 1
      t.string  :address1
      t.string  :address2
      t.string  :city
      t.string  :state,               :limit => 2
      t.string  :phone_no,            :limit => 20
      t.string  :verification_status

      t.timestamps
    end

    add_index :subscribers, :email
  end

  def self.down
    drop_table :subscribers
  end
end
