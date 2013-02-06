class AddDescriptionToQuizPhases < ActiveRecord::Migration
  # these are more or less in heirarchical order
  def self.up
    add_column :quiz_phases, :description, :string
  end

  def self.down
    remove_column :quiz_phases, :description
  end
end
