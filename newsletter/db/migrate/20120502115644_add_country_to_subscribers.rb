class AddCountryToSubscribers < ActiveRecord::Migration
  def self.up
    add_column :subscribers, :country, :string
  end

  def self.down
    remove_column :subscribers, :country
  end
end
