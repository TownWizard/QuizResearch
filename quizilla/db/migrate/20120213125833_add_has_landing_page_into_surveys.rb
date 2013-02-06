class AddHasLandingPageIntoSurveys < ActiveRecord::Migration
  def self.up
    add_column :surveys, :has_landing_page, :boolean, :default => true
  end

  def self.down
    remove_column :surveys, :has_landing_page
  end
end
